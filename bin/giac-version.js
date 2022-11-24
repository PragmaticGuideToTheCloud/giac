#!/usr/bin/env node

require('colors');
const fs = require('fs');
let packageJson = JSON.parse(fs.readFileSync(__dirname + '/../package.json'));

console.log(('giac version ' + packageJson.version).green);
