const fs = require('fs');
const glob = require('glob');
const nunjucks = require('nunjucks');
const { cfg } = require('./../src/globalConfig');

nunjucks.configure(cfg.tengine.templatesDir, cfg.tengine.nunjucks);

function getDirs(str) {
  let chunks = str.split('/');
  let result = [];
  let current = '';
  for (let i = 0; i < chunks.length - 1; i++) {
    current = current + chunks[i] + '/';
    result.push(current);
  }

  return result;
}

function mkDirs(str) {
  let dirs = getDirs(str);
  for (let i = 0; i < dirs.length; i++) {
    if (!fs.existsSync(dirs[i])) {
      fs.mkdirSync(dirs[i]);
    }
  }
}

function multipleStringReplace(str, vars) {
  let keys = Object.keys(vars);
  for (let i = 0; i < keys.length; i++) {
    let key = keys[i];
    str = str.replace(key, vars[key]);
  }

  return str;
}

function convertDirsIntoFiles(dirs) {
  let files = [];
  dirs.forEach(item => {
    let pattern = item.src + '/**';
    let found = glob.sync(pattern, { nodir: true, dot: true, cwd: __dirname + '/../templates/' });
    found.forEach(foundFile => {
      files.push({
        src: foundFile,
        dest: foundFile.replace(item.src, item.dest),
      });
    });
  });

  return files;
}

function appendIterationData(config, iterationData) {
  let result = config;
  let keys = Object.keys(iterationData);
  for (let i = 0; i < keys.length; i++) {
    let key = keys[i];
    result[key] = iterationData[key];
  }

  return result;
}

function execute(data) {
  let { baseDir, cfg, iterations, files, dirs, params } = data;

  files = files.concat(convertDirsIntoFiles(dirs));

  for (let k = 0; k < iterations.length; k++) {
    let iterationParams = appendIterationData(params, iterations[k]);
    for (let i = 0; i < files.length; i++) {
      let output = nunjucks.render(cfg.templatesDir + files[i].src, iterationParams);
      let outputFilename = multipleStringReplace(baseDir + files[i].dest, cfg.filenameConvertions);
      outputFilename = multipleStringReplace(outputFilename, iterations[k]);

      mkDirs(outputFilename);
      fs.writeFileSync(outputFilename, output);

      let re = /\.sh$/;
      if (outputFilename.match(re)) {
        fs.chmodSync(outputFilename, 0o775);
      }
    }
  }
}

module.exports = {
  execute,
};
