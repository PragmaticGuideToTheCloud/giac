#!/usr/bin/env node

require('colors');
const fs = require('fs');
const { cfg } = require('./../src/globalConfig');

let packageJson = JSON.parse(fs.readFileSync(__dirname + '/../package.json'));

console.log(('giac init ' + packageJson.version).green);

fs.writeFileSync(cfg.configFilename, fs.readFileSync(__dirname + '/../templates/' + cfg.configFilename));
