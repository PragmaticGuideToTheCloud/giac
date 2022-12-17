# GIAC / generate Infrastructure As Code

## How to install and run globally?

```
npm i -g git+ssh://git@github.com:PragmaticGuideToTheCloud/giac.git

/opt/homebrew/lib/node_modules/giac/bin/giac-version.js

/usr/local/lib/node_modules/giac/bin/giac-version.js
```

## How to use?

Create a new dir:

```
mkdir my-app
cd my-app
```

And create a new file `iac.yaml` with the following contents:

```
version: "1"

params:
  name: hello-cloud
  description: Hello, Cloud!
  app_repo: git@github.com:PragmaticGuideToTheCloud/hello-cloud.git
  provider:
    gcp:
      project_id: gcp_project_id_12345
  services:
    web:
      url: /
      dockerComposePorts:
        - 80:80
files:
  files/docker/dockerfiles/html.Dockerfile: docker/build/web.Dockerfile
  files/docker/test/docker-compose.yml: docker/test/docker-compose.yml

dirs:
  helm-charts/helm-chart-basic: helm-chart
```

Then run the command:

```
/opt/homebrew/lib/node_modules/giac/bin/giac-create.js
```

For more information about the syntax of `iac.yaml` file go to `examples/` folder.

## Development

### Run

```
npm i
./bin/giac-version.js
```

### Regenerate examples

```
./cleanup.sh
./bin/examples.js
```

## Applications

### Done

- redmine
- jenkins
- testlink
- airflow
- magento

### TBD

- sonarqube
- phpmyadmin
- pgadmin
- wordpress

- PrestaShop
- Odoo
- Moodle
- Media Wiki
- kibana
- joomla
- home assistant
- diaspora

- SuiteCRM

- consul
- vault
- terraform
- nomad

- gitlab
- locust
- owncast
- prometheus
- rocketchat
- ghost
- clearml


## Sources of applicaions

- https://github.com/unicodeveloper/awesome-opensource-apps
- https://github.com/alexwohlbruck/cat-facts
- https://github.com/sitepoint-editors/awesome-symfony
- https://gitlab.com/gitlab-org/gitlab

- https://github.com/helm/charts/tree/master/stable
- https://github.com/helm/charts

## Example config

```
files/auth/MakefileSecondGen: auth/Makefile
```
