const fs = require('fs');
const YAML = require('js-yaml');
const nunjucks = require('nunjucks');
const glob = require('glob');
const { cfg, giacDefaults } = require('./../src/globalConfig');
const tengine = require('./tengine');
const _ = require('lodash');
const { aolib } = require('private-libs');

nunjucks.configure(cfg.tengine.templatesDir, cfg.tengine.nunjucks);

function processOneProject(baseDir) {
  let configFilename = baseDir + cfg.configFilename;
  if (!fs.existsSync(configFilename)) {
    console.log('Missing config file.'.red);
    process.exit(1);
  }
  let config = readProjectConfig(configFilename);

  let defaults = null;
  let defaultsFilename = baseDir + cfg.deafaultsFilename;
  if (fs.existsSync(defaultsFilename)) {
    defaults = readProjectConfig(defaultsFilename);
  } else {
    defaults = giacDefaults;
  }

  let params = prepareParams(baseDir, config, defaults);

  let tengineData = {
    baseDir: baseDir,
    cfg: cfg.tengine,
    iterations: prepareIterations(params),
    files: prepareFiles(config, defaults),
    dirs: prepareDirs(config, params, defaults),
    params: params,
  };

  fs.writeFileSync(baseDir + '/tengine.dump.yaml', YAML.dump(tengineData));

  tengine.execute(tengineData);
}

function readProjectConfig(configFilename) {
  let configFileContents = fs.readFileSync(configFilename).toString();
  let config = YAML.load(configFileContents);
  config = YAML.load(nunjucks.renderString(configFileContents, config.params));

  return config;
}

function prepareParams(baseDir, config, defaults) {
  let params = _.defaultsDeep(config.params, defaults.params);

  if (params.provider.gcp.autoZone) {
    let gcpAutoZoneData = getGcpAutoZoneDataRegion(params.provider.gcp.autoZone);
    params.provider.gcp = _.defaults(gcpAutoZoneData, params.provider.gcp);
  }

  let ansibleBoilerplateUrl = autoGuessAnsibleRepoUrl(params.provider.gcp.vpc.boilerplate);
  params.ansibleBoilerplateUrl = ansibleBoilerplateUrl;

  let processedServicesAndContainers = processServicesAndContainers(baseDir, config.params);

  params.containers = aolib.deepCopy(processedServicesAndContainers.containers);
  params.dockerServices = aolib.deepCopy(processedServicesAndContainers.services);
  params.helmServices = aolib.deepCopy(processedServicesAndContainers.helmServices);

  return params;
}

function prepareIterations(params) {
  let iterations = [];
  for (let k = 0; k < params.provider.gcp.envs.length; k++) {
    let env = parseEnv(params.provider.gcp.envs[k]);
    iterations.push({
      __VPC_NAME__: env[0],
      __ENV_NAME__: env[1],
    });
  }

  return iterations;
}

function prepareFiles(config, defaults) {
  const giacDefaultDockerFiles = {
    'files/docker/build/gitignore': 'docker/build/gitignore',
    'files/docker/build/dockerignore': 'docker/build/dockerignore',
    'files/docker/test/env': 'docker/test/.env',
  };

  /**
   * Attention: files can contain duplicated dest paths
   * Destination path can exist in defaults and in params
   * with the same key and different values.
   */

  let includeGiacDefaultDockerFiles = false;
  if (config.files) {
    let keys = Object.keys(config.files);
    for (let i = 0; i < keys.length; i++) {
      let key = keys[i];
      if (key.match(/^files\/docker\/dockerfiles\//)) {
        includeGiacDefaultDockerFiles = true;
      }
    }
  }

  let files = { ...defaults.files, ...config.files };

  if (includeGiacDefaultDockerFiles) {
    files = { ...files, ...giacDefaultDockerFiles };
  }

  // we add default docker files
  // only if at least one dockerfile entry is present
  // in files
  if (includeGiacDefaultDockerFiles) {
    if (config.params.app_repo) {
      files['files/docker/build/Makefile'] = 'docker/build/Makefile';
    } else {
      files['files/docker/build/Makefile-no-src'] = 'docker/build/Makefile';
    }
  }

  files = [].concat(
    aolib.objToArray(files, (key, value) => {
      return {
        src: key,
        dest: value,
      };
    }),
  );

  return files;
}

function prepareDirs(config, params, defaults) {
  /**
   * Attention: dirs can contain duplicated dest paths
   * Destination path can exist in defaults and in params
   * with the same key and different values.
   */
  let dirs = { ...defaults.dirs, ...config.dirs };

  params.terraform.forEach(item => {
    dirs['terragrunt/' + item] = 'terragrunt/' + item;
  });

  dirs = [].concat(
    aolib.objToArray(dirs, (key, value) => {
      return {
        src: key,
        dest: value,
      };
    }),
  );

  return dirs;
}

function parseEnv(env) {
  return env.split('/');
}

function autoGuessAnsibleRepoUrl(url) {
  if (!url) {
    return null;
  }

  let regExp = /(git@.*\.git)/;
  const found = url.match(regExp);
  return found[1].replace('git@github.com/', 'git@github.com:');
}

function getContainerSrcCodePath(params, name) {
  if (!params.services) {
    return '';
  }

  let keys = Object.keys(params.services);
  for (let i = 0; i < keys.length; i++) {
    let key = keys[i];
    if (key == name) {
      return params.services[key].srcCodePath;
    }
  }

  return '';
}

function applySericeConfiguration(services, helmMicroConfig) {
  for (let i = 0; i < services.length; i++) {
    let name = services[i].name;
    services[i].type = 'NodePort';
    services[i] = { ...services[i], ...helmMicroConfig[name] };
  }

  return services;
}

function getGcpAutoZoneDataRegion(zone) {
  let zones = YAML.load(fs.readFileSync(__dirname + '/../data/zones.yaml'));
  let subnetworks = YAML.load(fs.readFileSync(__dirname + '/../data/subnetworks.yaml'));

  let region = zones[zone];
  if (!region) {
    throw 'Zone "' + zone + '" not found!';
  }
  let result = {
    zone: zone,
    region: region,
    cidr_block: subnetworks[region].ip_cidr_range,
    master_ipv4_cidr_block: subnetworks[region].ip_cidr_range.replace(/.0.0\/20$/, '.16.0/28'),
    peer_routes: subnetworks[region].ip_cidr_range.replace(/.0.0\/20$/, '.0.0/16'),
  };

  return result;
}

function isServiceDefined(services, name) {
  for (let i = 0; i < services.length; i++) {
    if (services[i].name === name) {
      return true;
    }
  }
  return false;
}

function processServicesAndContainers(baseDir, params) {
  // containers are used in Makefile for container building
  let containers = [];

  // services are used in helm values.yaml and docker-compose.yaml
  let services = [];

  // autoguess containers & services using docker/build/*.Dockerfile
  let dockerContainersDir = 'docker/build/';
  let pattern = '*.Dockerfile';
  let found = glob.sync(pattern, { cwd: baseDir + '/' + dockerContainersDir });
  found.forEach(item => {
    let containerName = item.match(/^(.*)\.Dockerfile$/);
    let name = containerName[1];
    containers.push({
      name: name,
      srcCodePath: getContainerSrcCodePath(params, name),
    });

    services.push({
      name: name,
      nodePort: 1,
      url: '',
    });
  });

  // add manually configured services/containers
  if (params.services) {
    let keys = Object.keys(params.services);
    for (let i = 0; i < keys.length; i++) {
      let key = keys[i];
      if (!isServiceDefined(services, key)) {
        services.push({
          name: key,
          image: params.services[key].image,
          url: '',
          excludeFromHelm: true,
        });
      }
    }
  }

  // append all config from services key from iac.yaml
  // to autoguessed services (based on *.Dockerfile)
  let helmMicroConfig = {};
  if (params.services) {
    helmMicroConfig = params.services;
  }
  services = applySericeConfiguration(services, helmMicroConfig);

  services = services.sort((a, b) => {
    if (a.name === 'traefik') {
      return -1;
    }

    return a.url.localeCompare(b.url);
  });

  containers = containers.sort(a => {
    if (a.name === 'traefik') {
      return -1;
    } else {
      return 1;
    }
  });

  let nodePort = 32767;
  for (let i = 0; i < services.length; i++) {
    if (services[i].name === 'traefik') {
      // we need this value in values.yaml template
      services[i].excludeFromHelm = true;
    }
    if (services[i].excludeFromHelm) {
      continue;
    }
    services[i].nodePort = nodePort;
    nodePort--;
  }

  for (let i = 0; i < services.length; i++) {
    if (params.dockerComposeServiceNaming === 'long') {
      services[i].dockerComposeServiceName = params.name + '-' + services[i].name;
    } else {
      services[i].dockerComposeServiceName = services[i].name;
    }
  }

  // filter services for helm
  let helmServices = [];
  services.forEach(item => {
    if (!item.excludeFromHelm) {
      helmServices.push(item);
    }
  });

  return {
    containers: containers,
    services: services,
    helmServices: helmServices,
  };
}

module.exports = {
  processOneProject,
};
