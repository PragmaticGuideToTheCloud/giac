const cfg = {
  configFilename: 'iac.yaml',
  deafaultsFilename: 'giac.yaml',
  tengine: {
    templatesDir: __dirname + '/../templates/',
    nunjucks: {
      autoescape: false,
      tags: {
        variableStart: '<<<',
        variableEnd: '>>>',

        blockStart: '<%',
        blockEnd: '%>',
      },
    },
    filenameConvertions: {
      gitignore: '.gitignore',
      dockerignore: '.dockerignore',
      gitkeep: '.gitkeep',
    },
  },
};

const giacDefaults = {
  params: {
    provider: {
      gcp: {
        envs: ['dev/dev1'],
        vpc: {
          boilerplate:
            'git::ssh://git@github.com/PragmaticGuideToTheCloud/gcp-cloud-boilerplate.git//terraform/vpc',
        },
        gke: {
          boilerplate:
            'git::ssh://git@github.com/PragmaticGuideToTheCloud/gcp-cloud-boilerplate.git//terraform/gke-public-plane',
        },
        gsa: {
          boilerplate:
            'git::ssh://git@github.com/PragmaticGuideToTheCloud/gcp-cloud-boilerplate.git//terraform/gsa',
        },
        global_address: {
          boilerplate:
            'git::ssh://git@github.com/PragmaticGuideToTheCloud/gcp-cloud-boilerplate.git//terraform/global-address',
        },
        autoZone: false,
      },
    },
    container_registry: 'eu.gcr.io',
    terraform: ['vpc', 'gke', 'gsa'],
  },
  files: {
    'files/auth/Makefile': 'auth/Makefile',
    'files/helm/deploy.sh': 'helm/deploy.sh',
    'files/helm/values.yaml': 'helm/values.yaml',
    'files/README.md': 'README.md',
    'files/giac-doc.md': 'giac-doc.md',
    'terragrunt/terragrunt.hcl': 'terragrunt/terragrunt.hcl',
    'files/gitignore': 'gitignore',
  },
  dirs: {
    tests: 'tests',
  },
};

module.exports = {
  cfg,
  giacDefaults,
};
