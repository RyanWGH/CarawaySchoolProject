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
const MAIN_PAGE = role => `/${role}/main`;
const DONATE_PAGE = role => `/${role}/donate`;
const DAY_PAGE = role => `/${role}/DaySchedule`;
const MONTH_PAGE = role => `/${role}/monthSchedule`;
const REQUESTS_PAGE = role => `/${role}/requests`;
const CONTACT_PAGE = role => `/${role}/contact`;
const WEEK_STATS_PAGE = role => `/${role}/weekStats`;
const TOTAL_STATS_PAGE = role => `/${role}/totalStats`;
const ADD_FAMILY_PAGE = role => `/${role}/addFamily`;

const generalEndpoints = {
  "/": (req, res, role) => {
    if (role) {
      serveFile(req, res, MAIN_PAGE(role));
    } else {
      serveFile(req, res, LOGIN_PAGE);
    }
    return 1;
  },

  "/main": (req, res, role) => {
    serveFile(req, res, MAIN_PAGE(role));
    return 1;
  },

  "/login": (req, res) => {
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
  },

  "/familytest": (req, res) => {
    console.log('familytest');
    getFamilyNames(() => {});
    return 1;
  }
};

const userEndpoints = {
  "/user": (req, res, role) => {
    serveFile(req, res, MAIN_PAGE(role));
    return 1;
  },

  "/donate": (req, res, role) => {
    serveFile(req, res, DONATE_PAGE(role));
    return 1;
  },

  "/DaySchedule": (req, res, role) => {
    serveFile(req, res, DAY_PAGE(role));
    return 1;
  },

  "/requests": (req, res, role) => {
    serveFile(req, res, REQUESTS_PAGE(role));
    return 1;
  },

  "/contact": (req, res, role) => {
    serveFile(req, res, CONTACT_PAGE(role));
    return 1;
  },

  "/monthSchedule": (req, res, role) => {
    serveFile(req, res, MONTH_PAGE(role));
    return 1;
  },

  "/contact": (req, res, role) => {
    serveFile(req, res, CONTACT_PAGE(role));
    return 1;
  },

  "/addfacilitator": (req, res, role) => {
    let sessionID = cookie.parse(req.headers.cookie || "").sessionid;

    lookupSession(req, res, sessionID, (validSession) => {
      if (!validSession) {
        console.log("invalid session trying to sign up");
        return;
      }

      let body = '';
      req.on("data", (data) => {
        body += data;
        if (body.length > 1e6) {
          req.connection.destroy();
        }
      });

      req.on("end", () => {
        let data = qs.parse(body);
        console.log(data);
        res.end(JSON.stringify(data));
      });
    });

    return 1;
  },

  "/request_absence": (req, res, role) => {
  	let sessionID = cookie.parse(req.headers.cookie || "").sessionid;
  	//getting the info from the webpage(user)
  	lookupSession(req, res, sessionID, (validSession, role, user) => {
      //checking if the session ID is valid
      if (!validSession) {
        console.log("invalid session trying to sign up");
        return;
      }

      let body = '';
      req.on("data", (data) => {
        body += data;
        if (body.length > 1e6) {
          req.connection.destroy();
        }
      });

      req.on("end", () => {
        let data = qs.parse(body);
        requestAbsence( user.userid, data.FromDate, data.ToDate, (err) => {
            if (!err) {
              res.end("Request successfully added");
            }
            });
      });
    });

    return 1;
  },
};

const teacherEndpoints = {
  "/teacher": (req, res, role) => {
    serveFile(req, res, MAIN_PAGE(role));
    return 1;
  },

  "/DaySchedule": (req, res, role) => {
    serveFile(req, res, DAY_PAGE(role));
    return 1;
  }
};

const boardEndpoints = {
  "/board": (req, res, role) => {
    serveFile(req, res, MAIN_PAGE(role));
    return 1;
  }
};

const adminEndpoints = {
  "/admin": (req, res, role) => {
    serveFile(req, res, MAIN_PAGE(role));
    return 1;
  },

  "/DaySchedule": (req, res, role) => {
    serveFile(req, res, DAY_PAGE(role));
    return 1;
  },

  "/monthSchedule": (req, res, role) => {
    serveFile(req, res, MONTH_PAGE(role));
    return 1;
  },

  "/totalStats": (req, res, role) => {
    serveFile(req, res, TOTAL_STATS_PAGE(role));
    return 1;
  },

  "/weekStats": (req, res, role) => {
    serveFile(req, res, WEEK_STATS_PAGE(role));
    return 1;
  },

  "/addFamily": (req, res, role) => {
    serveFile(req, res, ADD_FAMILY_PAGE(role));
    return 1;
  },

  "/getfamilies": (req, res, role) => {
    getFamilyNames((err, names) => {
      if (!err) {
        res.end(JSON.stringify(names));
      }
    });
    return 1;
  },

  "/getfacilitators": (req, res, role) => {
    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });

    req.on("end", () => {
      let data = qs.parse(body);

      getFacilitatorNames(data.familyid, (err, names) => {
        if (!err) {
          res.end(JSON.stringify(names));
        }
      });
    });
    return 1;
  },

  "/Addfacilitator": (req, res, role) => {
    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });

    req.on("end", () => {
      let data = qs.parse(body);

      insertFacilitation(data.Facilitator, data.roomid, data.StartTime,
          data.EndTime, data.day, data.month, data.year, (err) => {
            if (!err) {
              res.end("Facilitator successfully added");
            }
          });
    });
    return 1;
  },

  "/Deletefacilitator": (req, res, role) => {
    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });

    req.on("end", () => {
      let data = qs.parse(body);

      deleteFacilitation(data.Facilitator, data.roomid, data.StartTime,
        data.EndTime, data.day, data.month, data.year, (err) => {
          if (!err) {
            res.end("Facilitator successfully deleted");
          }
        });
    });
    return 1;
  },

  "/ApproveAbsence": (req, res, role) => {
  	let body = '';
  	req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });

    req.on("end", () => {
      let data = qs.parse(body);

      approveAbsence(data.absenceId, (err) => {
        if(!err) {
          res.end("Absence Succesfully Approved");
        }
      });
    });
    return 1;
  },

  "/DenyAbsence": (req, res, role) => {
    let body = '';
    req.on("data", (data) => {
  	   body += data;
       if (body.length > 1e6) {
         req.connection.destroy();
       }
     });

  	req.on("end", () => {
  		let data = qs.parse(body);
      denyAbsence(data.absenceId, (err) => {
        if(!err) {
          res.end("Absence denied");
        }
  	   });
     });
     return 1;
   }
};

function getFamilyNames(callback) {
  db.query(`SELECT firstname, lastname, familyunitid
    from familymembers as f1, users as f2
    where f1.userid = f2.userid and f1.userid in
    (select distinct userid from familymembers
    where familyunitid = f1.familyunitid
    limit 1) order by lastname`, (err, res) => {
      if (err) {
        console.log(err.stack);
        callback(true);
      } else {
        callback(null, res.rows);
      }
    });
}

function getFacilitatorNames(familyid, callback) {
  db.query(`SELECT firstname, lastname, f2.userid
    FROM familymembers as f1, users as f2
    WHERE f1.userid = f2.userid
    and f1.familyunitid = ${familyid}`, (err, res) => {
      if (err) {
        console.log(err.stack);
        callback(true);
      } else {
        callback(null, res.rows);
      }
    });
}

function insertFacilitation(userid, roomid, start, end, day, month, year, callback) {
  db.query(`INSERT INTO facilitations (userid, roomid, timeStart, timeEnd, day, month, year)
    VALUES(${userid}, ${roomid}, '${start}', '${end}', ${day}, ${month}, ${year})`,
    (err) => {
      if (err) {
        console.log(err.stack);
        callback(true);
      } else {
        callback(null);
      }
    });
}

function deleteFacilitation(userid, roomid, start, end, day, month, year, callback) {
  db.query(`UPDATE facilitations SET timeStart = '${start}', timeEnd = '${end}'
    WHERE userid = ${userid} AND roomid = ${roomid} AND day = ${day} AND month = ${month} AND year = ${year}`,
    (err) => {
      if (err) {
        console.log(err.stack);
        callback(true);
      } else {
        callback(null);
      }
    });
}

function requestAbsence(userId, fromDate, toDate, callback) {
	db.query(`SELECT familyUnitId from familyMembers where userId = '${userId}'`, (err, res) => {
    if (err) {
      console.log(err.stack);
      callback(true);
    } else {
      let familyId = res.rows[0].familyunitid;
      // status pending =1
      db.query(`INSERT into absences (fromDate, toDate, familyUnitId, status) values('${fromDate}','${toDate}', ${familyId}, 1)`,(err) => {
        if (err) {
          console.log(err.stack);
          callback(true);
        } else {
          callback(null);
        }
      });
    }
  });
}

function approveAbsence(absenceId, callback) {
	db.query(`UPDATE absences set status = 2 WHERE absenceId = ${absenceId}`, (err) => {
    if (err) {
      console.log(err.stack);
      callback(true);
    } else{
      callback(null);
    }
  });
}

function denyAbsence(absenceId, callback) {
	db.query(`UPDATE absences set status = 0 WHERE absenceId = ${absenceId}`, (err) => {
    if (err) {
      console.log(err.stack);
      callback(true);
    } else{
      callback(null);
    }
  });
}

function serveFile(req, res, pathname) {
  let path = `.${pathname}`;
  fs.exists(path, (exist) => {
    if (!exist) {
      res.statusCode = 404;
      res.end(`File not found: ${path}`);
      return;
    }

    if (fs.statSync(path).isDirectory()) {
      path += '/index.html';
    }

    fs.readFile(path, (err, data) => {
      if (err) {
        res.statusCode = 500;
        res.end(`Error getting file: ${path}`);
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
  db.query(`SELECT userid, firstname, lastname, email, phone
    FROM users WHERE sessionid = '${id}'`, (err, result) => {
    if (err) {
      console.log(err.stack);
      callback(false);
    } else {
      let user = result.rows[0];
      if (user) {
        db.query(`SELECT * FROM admins WHERE userid = ${user.userid}`, (err, adminRes) => {
          if (err) {
            console.log(err.stack);
            callback(false);
          } else {
            if (adminRes.rows[0]) {
              callback(true, "admin", user);
            } else {
              db.query(`SELECT * FROM boards WHERE userid = ${user.userid}`, (err, boardRes) => {
                if (err) {
                  console.log(err.stack);
                  callback(false);
                } else {
                  if (boardRes.rows[0]) {
                    callback(true, "board", user);
                  } else {
                    db.query(`SELECT * FROM teachers WHERE userid = ${user.userid}`, (err, teacherRes) => {
                      if (err) {
                        console.log(err.stack);
                        callback(false);
                      } else {
                        if (teacherRes.rows[0]) {
                          callback(true, "teacher", user);
                        } else {
                          callback(true, "user", user);
                        }
                      }
                    });
                  }
                }
              });
            }
          }
        });
      } else {
        callback(false);
      }
    }
  });
}

function handleEndpoint(req, res, endpoint, role) {
  let status = 0;

  if (endpoint in generalEndpoints) {
    status = generalEndpoints[endpoint](req, res, role);
    if (status) {
      return;
    }
  }

  switch (role) {
    case "admin":
      if (endpoint in adminEndpoints) {
        status = adminEndpoints[endpoint](req, res, role);
      }
      break;
    case "board":
      if (endpoint in boardEndpoints) {
        status = boardEndpoints[endpoint](req, res, role);
      }
      break;
    case "teacher":
      if (endpoint in teacherEndpoints) {
        status = teacherEndpoints[endpoint](req, res, role);
      }
      break;
    case "user":
      if (endpoint in userEndpoints) {
        status = userEndpoints[endpoint](req, res, role);
      }
      break;
    default:
      if (endpoint in generalEndpoints) {
        status = generalEndpoints[endpoint](req, res, role);
      }
      break;
  }

  if (status) {
    return;
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
    lookupSession(req, res, sessionID, (validSession, role) => {
      if (validSession) {
        handleEndpoint(req, res, endpoint, role);
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
