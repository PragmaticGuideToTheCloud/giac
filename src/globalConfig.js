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
        autoZone: false,
      },
    },
    container_registry: 'eu.gcr.io',
    terraform: ['vpc', 'gke', 'gsa'],
  },
  files: {
    'files/auth/Makefile': 'auth/Makefile',
    'files/helm/deploy.sh': 'helm/__VPC_NAME__/__ENV_NAME__/deploy.sh',
    'files/helm/values.yaml': 'helm/__VPC_NAME__/__ENV_NAME__/values.yaml',
    'files/README.md': 'README.md',
    'files/giac-doc.md': 'giac-doc.md',
    'terraform/terragrunt.hcl': 'terraform/terragrunt.hcl',
    'terraform/gitignore': 'terraform/gitignore',
  },
  dirs: {
    ansible: 'ansible',
    tests: 'tests',
    vpn: 'vpn',
  },
};

module.exports = {
  cfg,
  giacDefaults,
};
