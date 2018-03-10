const http = require("http");
const fs = require("fs");
const url = require("url");
const path = require("path");
const qs = require("querystring");
const { Client } = require("pg");
const db = new Client();

db.connect();

http.createServer((req, res) => {
  let parsedUrl = url.parse(req.url);
  let pathname = `.${parsedUrl.pathname}`;

  // login
  if (parsedUrl.path == "/logincheck") {
    let body = '';
    req.on('data', (data) => {
      body += data;
      // 1e6 === 1 * Math.pow(10, 6) === 1 * 1000000 ~~~ 1MB
      if (body.length > 1e6) {
        // FLOOD ATTACK OR FAULTY CLIENT, NUKE REQUEST
        req.connection.destroy();
      }
    });
    req.on('end', () => {
      let data = qs.parse(body);

      //check if data.usr and data.pwd are valid
      db.query('some sort of query string', ['Hello world!'], (err, res) => {
        console.log(err ? err.stack : res.rows[0].message); // Hello World!

        //if valid login, redirect user to index page
        // with return res.redirect("/index.html");

        //else, bring back to /login.html with error message?
        // with return res.redirect("/login.html");
      });

    });
    return;
  }


  // file server
  fs.exists(pathname, (exist) => {
    if (!exist) {
      res.statusCode = 404;
      res.end("File not found");
      return;
    }

    if (fs.statSync(pathname).isDirectory()) {
      pathname += '/index.html';
    }

    fs.readFile(pathname, (err, data) => {
      if (err) {
        res.statusCode = 500;
        res.end("Error getting file");
      } else {
        //res.setHeader('Content-type', 'text/html');
        res.end(data);
      }
    });
  });

}).listen(8080);

console.log("listening on port 8080");
