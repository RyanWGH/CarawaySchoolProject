let http = require("http");
let fs = require("fs");
let url = require("url");
let path = require("path");

http.createServer(function(req, res) {
  let parsedUrl = url.parse(req.url);
  let pathname = `.${parsedUrl.pathname}`

  fs.exists(pathname, function(exist) {
    if (!exist) {
      res.statusCode = 404;
      res.end("File not found");
      return;
    }

    if (fs.statSync(pathname).isDirectory()) {
      pathname += '/index.html';
    }

    fs.readFile(pathname, function(err, data) {
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
