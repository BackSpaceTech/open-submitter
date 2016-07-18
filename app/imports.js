// Generated by CoffeeScript 1.3.3
(function() {
  var consolex, fs;

  fs = require('fs');

  consolex = require('./console-xtra');

  exports.accounts = function(filePath) {
    var a, buffer, ins, temp, tempAccounts;
    tempAccounts = [];
    if (fs.exists(filePath) && fs.isFile(filePath)) {
      console.log('Loading user accounts...');
      ins = fs.open(filePath, 'r');
      a = 0;
      while (!ins.atEnd()) {
        buffer = ins.readLine();
        temp = buffer.split(/\s*,\s*/);
        tempAccounts[a] = {
          accountType: temp[0],
          loginID: temp[1],
          password: temp[2],
          siteName: temp[3]
        };
        ++a;
      }
      return tempAccounts;
    } else {
      return console.log('Could not load ' + filePath);
    }
  };

  exports.articles = function(filePath) {
    var a, articleStatus, buffer, firstLine, ins, temp, tempArticles;
    tempArticles = [];
    articleStatus = '';
    firstLine = false;
    if (fs.exists(filePath) && fs.isFile(filePath)) {
      console.log('Loading articles...');
      ins = fs.open(filePath, 'r');
      a = -1;
      while (!ins.atEnd()) {
        buffer = ins.readLine();
        temp = buffer.trim();
        if (temp === '#Title') {
          articleStatus = 'title';
          ++a;
          tempArticles[a] = {
            title: '',
            description: '',
            body: '',
            keywords: '',
            links: '',
            images: ''
          };
        } else if (temp === '#Body') {
          articleStatus = 'body';
          firstLine = true;
        } else if (temp === '#Keywords') {
          articleStatus = 'keywords';
        } else if (temp === '#Links') {
          articleStatus = 'links';
        } else if (temp === '#Images') {
          articleStatus = 'images';
        } else if (articleStatus === 'title') {
          tempArticles[a].title += temp;
        } else if (articleStatus === 'body') {
          if (firstLine && temp !== '') {
            tempArticles[a].description = temp + '<br>';
            firstLine = false;
          }
          tempArticles[a].body += temp + '<br>';
        } else if (articleStatus === 'keywords') {
          temp = buffer.split(/\s*,\s*/);
          tempArticles[a].keywords = temp;
        } else if (articleStatus === 'links') {
          temp = buffer.split(/\s*,\s*/);
          tempArticles[a].links = temp;
        } else if (articleStatus === 'images') {
          temp = buffer.split(/\s*,\s*/);
          tempArticles[a].images = temp;
        }
      }
      ins.close();
      a = 0;
      return tempArticles;
    } else {
      return console.log('Could not load ' + filePath);
    }
  };

  exports.indexers = function(filePath) {
    var a, buffer, i, ins, status, temp, temp2, tempIndexers, tempIndexers2, _i, _ref;
    tempIndexers = [];
    status = '';
    if (fs.exists(filePath) && fs.isFile(filePath)) {
      ins = fs.open(filePath, 'r');
      a = -1;
      while (!ins.atEnd()) {
        buffer = ins.readLine();
        temp = buffer.trim();
        if (temp === '#name#') {
          status = 'name';
          ++a;
          tempIndexers[a] = {
            name: '',
            username: '',
            password: '',
            status: ''
          };
        } else if (temp === '#username#') {
          status = 'username';
        } else if (temp === '#password#') {
          status = 'password';
        } else if (temp === '#status#') {
          status = 'status';
        } else if (status === 'name') {
          tempIndexers[a].name = temp;
          status = '';
        } else if (status === 'username') {
          tempIndexers[a].username = temp;
          status = '';
        } else if (status === 'password') {
          tempIndexers[a].password = temp;
          status = '';
        } else if (status === 'status') {
          tempIndexers[a].status = temp;
          status = '';
        }
      }
      ins.close();
      a = 0;
      temp2 = 0;
      tempIndexers2 = [];
      for (i = _i = 0, _ref = tempIndexers.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        if (tempIndexers[i].status.toLowerCase() === 'ok') {
          tempIndexers2[temp2] = tempIndexers[i];
          ++temp2;
        }
      }
      return tempIndexers2;
    } else {
      return console.log('Could not load ' + filePath);
    }
  };

  exports.services = function(filePath) {
    var a, buffer, ins, status, temp, tempServices;
    tempServices = [];
    status = '';
    if (fs.exists(filePath) && fs.isFile(filePath)) {
      ins = fs.open(filePath, 'r');
      a = -1;
      while (!ins.atEnd()) {
        buffer = ins.readLine();
        temp = buffer.trim();
        if (temp === '#name#') {
          status = 'name';
          ++a;
          tempServices[a] = {
            name: '',
            status: ''
          };
        } else if (temp === '#status#') {
          status = 'status';
        } else if (status === 'name') {
          tempServices[a].name = temp;
        } else if (status === 'status') {
          tempServices[a].status = temp;
        }
      }
      ins.close();
      a = 0;
      return tempServices;
    } else {
      return console.log('Could not load ' + filePath);
    }
  };

}).call(this);
