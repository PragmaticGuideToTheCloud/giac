#!/usr/bin/env node

require('colors');
const app = require('./../src/app');
const fs = require('fs');

let packageJson = JSON.parse(fs.readFileSync(__dirname + '/../package.json'));

console.log(('giac create ' + packageJson.version).green);

let baseDir = './';

app.processOneProject(baseDir);
app.processOneProject(baseDir);
