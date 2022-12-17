#!/usr/bin/env node

require('colors');
const app = require('./../src/app');
const fs = require('fs');

let packageJson = JSON.parse(fs.readFileSync(__dirname + '/../package.json'));

console.log(('giac examples ' + packageJson.version).green);

let examples = [
  'examples/empty-iac/',

  'examples/hello-cloud-iac/',
  'examples/hello-ssh-iac/',
  'examples/fantastic-iac/',

  'examples/today-java-iac/',
  'examples/today-js-iac/',
  'examples/today-php-iac/',
  'examples/today-python-iac/',
  'examples/today-ruby-iac/',

  'examples/api-java-poems-iac/',
  'examples/api-ruby-proverbs-iac/',
  'examples/api-php-quotations-iac/',
  'examples/api-js-songs-iac/',
  'examples/api-python-writers-iac/',

  'examples/api-microservices-iac/',

  'examples/geo-js-deserts-iac/',
  'examples/geo-java-mountains-iac/',
  'examples/geo-php-cities-iac/',
  'examples/geo-python-rivers-iac/',
  'examples/geo-ruby-lakes-iac/',

  'examples/memorize-it-iac/',
  'examples/redmine-iac/',
  'examples/testlink-iac/',
  'examples/jenkins-iac/',
  'examples/magento-iac/',
  'examples/airflow-iac/',

  'examples/postmortem-iac/',
];

examples.forEach(baseDir => {
  console.log(baseDir);
  app.processOneProject(baseDir);
  app.processOneProject(baseDir);
});
