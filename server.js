const http = require("http");
const fs = require("fs");
const url = require("url");
const path = require("path");
const qs = require("querystring");
const cookie = require("cookie");
const crypto = require("crypto");
const { Client } = require("pg");

const db = new Client();
db.connect();

const ALGORITHM = "aes192";
const SECRET = "orange!";
const LOGIN_PAGE = "/html/login";
const MAIN_PAGE = "/html/main";
const DONATE_PAGE = "/html/donate";
const SCHEDULE_PAGE = "/html/schedule";
const REQUESTS_PAGE = "/html/requests";
const CONTACT_PAGE = "/html/contact";

const endpoints = {
  "/": (req, res) => {
    serveFile(req, res, MAIN_PAGE);
    return 1;
  },

  "/main": (req, res) => {
    serveFile(req, res, MAIN_PAGE);
    return 1;
  },

  "/donate": (req, res) => {
    serveFile(req, res, DONATE_PAGE);
    return 1;
  },

  "/schedule": (req, res) => {
    serveFile(req, res, SCHEDULE_PAGE);
    return 1;
  },

  "/requests": (req, res) => {
    serveFile(req, res, REQUESTS_PAGE);
    return 1;
  },

  "/contact": (req, res) => {
    serveFile(req, res, CONTACT_PAGE);
    return 1;
  },

  "/login": (req, res) => {
    console.log("reached /login endpoint");

    let cookies = cookie.parse(req.headers.cookie || "");
    let sessionID = cookies.sessionID;

    if (sessionID) {
      lookupSession(req, res, id, (validSession) => {
        if (validSession) {
          res.statusCode = 302;
          res.setHeader("Location", "/main");
          res.end();
        } else {
          res.statusCode = 302;
          res.setHeader("Location", "/login");
          res.end();
        }
      });
    } else {
      serveFile(req, res, LOGIN_PAGE);
    }

    return 1;
  },

  "/logincheck": (req, res) => {

    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });

    req.on("end", () => {
      let data = qs.parse(body);

      db.query('SELECT * FROM users WHERE email = $1 AND pword = $2', [data.usr, data.pwd], (err, result) => {
        if (err) {
          console.log(err.stack);
          return;
        }

        if (!result.rows[0]) {
          res.statusCode = 302;
          res.setHeader('Location', '/login');
          res.end();
          return;
        }

        // successful login
        let sessionID = createSessionID(result.rows[0]);

        db.query('UPDATE users SET sessionid = $1 WHERE userid = $2', [sessionID, result.rows[0].userid], (err) => {
          if (err) {
            console.log(err.stack);
            return;
          }

          res.setHeader('Set-Cookie', cookie.serialize("sessionid", sessionID));
          res.statusCode = 302;
          res.setHeader('Location', "/main");
          res.end();
        });
      });
    });

    return 1;
  },

  "/logout": (req, res) => {
    let sessionID = cookie.parse(req.headers.cookie || "").sessionid;

    db.query("UPDATE users SET sessionid = null WHERE sessionid = $1", [sessionID], (err) => {
      if (err) {
        return;
      }
      res.setHeader('Set-Cookie', "");
      res.setHeader("Location", "/login");
      res.statusCode = 302;
      res.end();
    });
    
    return 1;
  }
};

function serveFile(req, res, pathname) {
  let path = `.${pathname}`;
  fs.exists(path, (exist) => {
    if (!exist) {
      res.statusCode = 404;
      res.end("File not found");
      return;
    }

    if (fs.statSync(path).isDirectory()) {
      path += '/index.html';
    }

    fs.readFile(path, (err, data) => {
      if (err) {
        res.statusCode = 500;
        console.log(path);
        res.end("Error getting file");
      } else {
        res.end(data);
      }
    });
  });
}

function encrypt(text) {
  let cipher = crypto.createCipher(ALGORITHM, SECRET);
  let output = cipher.update(text, "utf8", "hex");
  output += cipher.final("hex");
  return output;
}

function decrypt(text) {
  let cipher = crypto.createDecipher(ALGORITHM, SECRET);
  let output = cipher.update(text, "hex", "utf8");
  output += cipher.final("utf8");
  return output;
}

function createSessionID(user) {
  return encrypt('' + Date.now() + '-' + user.email);
}

function lookupSession(req, res, id, callback) {
  db.query("SELECT * FROM users WHERE sessionid = $1", [id], (err, result) => {
    if (err) {
      console.log(err.stack);
      callback(false);
    } else {
      if (result.rows[0]) {
        console.log("session is valid!");
        callback(true);
      } else {
        callback(false);
      }
    }
  });
}

function handleEndpoint(req, res, endpoint) {
  if (endpoint in endpoints) {
    let status = endpoints[endpoint](req, res);
    if (status) {
      return;
    }
  }

  serveFile(req, res, endpoint);
}

const defaultFiles = [
  "/login",
  "/logincheck",
  "/assets/CarawayLogo.png",
  "/html/login",
  "/html/login/index.html"
];

http.createServer((req, res) => {

  let endpoint = url.parse(req.url).path;

  let cookies = cookie.parse(req.headers.cookie || "");
  let sessionID = cookies.sessionid;

  if (defaultFiles.includes(endpoint)) {
    handleEndpoint(req, res, endpoint);
  }

  else if (sessionID && sessionID.length > 0) {
    lookupSession(req, res, sessionID, (validSession) => {
      if (validSession) {
        handleEndpoint(req, res, endpoint);
      } else {
        res.setHeader('Set-Cookie', '');
        res.statusCode = 302;
        res.setHeader('Location', '/login');
        res.end();
      }
    });
  }

  else {
    handleEndpoint(req, res, "/login");
  }

}).listen(8080);

console.log("listening on port 8080");
