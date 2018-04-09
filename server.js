const http = require("http");
const fs = require("fs");
const url = require("url");
const path = require("path");
const qs = require("querystring");
const cookie = require("cookie");
const crypto = require("crypto");
const { Client } = require("pg");
const async = require("async");

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
const ABSENCE_LIST_PAGE = role => `/${role}/PendingAbsences`;
const EDIT_FAMILY = role => `/${role}/EditFamily`;
const EDIT_FACILITATOR = role => `/$role}/EditFacilitator`;
const CREATE_FAMILY = role => `/${role}/CreateFamily`;
const CHANGE_PASSWORD = role => `/${role}/ChangePassword`;
const ACCEPT_FACILITATOR = role => `/${role}/AcceptFacilitator`;
const ACCOUNT_SETTINGS = role => `/${role}/AccountSettings`;
const CREATE_FACILITATOR = role => `/${role}/CreateFacilitator`;
const ADD_CHILD = role => `/${role}/AddChild`;
const FIELD_TRIP = role => `/${role}/FieldTrip`;
const ADD_FIELD_TRIP = role => `/${role}/AddFieldTrip`;



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
  "/FieldTrip": (req, res, role) => {
    serveFile(req, res, FIELD_TRIP(role));
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
    "/CreateFacilitator": (req, res, role) => {
    serveFile(req, res, CREATE_FACILITATOR(role));
    return 1;
  },
  "/AccountSettings": (req, res, role) => {
    serveFile(req, res, ACCOUNT_SETTINGS(role));
    return 1;
  },
    "/ChangePassword": (req, res, role) => {
    serveFile(req, res, CHANGE_PASSWORD(role));
    return 1;
  },
    "/CreateFacilitator": (req, res, role) => {
    serveFile(req, res, CREATE_FACILITATOR(role));
    return 1;
  },

  "/getUpcomingfacilitations": (req, res, role, user) => {
     let body = '';

     req.on("data", (data) => {
       body += data;
       if (body.length > 1e6) {
         req.connection.destroy();
       }
     });

     req.on("end", () => {
       let data = qs.parse(body);

       getNextFacilitations(user.userid, data.day, data.month, data.year, (err, facilitations) => {
         if (!err) {
           res.end(JSON.stringify(facilitations));
         }
       });
     });
    return 1;
   },

  "/getChildren": (req, res, role, user) => {
     let body = '';

     req.on("data", (data) => {
       body += data;
       if (body.length > 1e6) {
         req.connection.destroy();
       }
     });

     req.on("end", () => {
       let data = qs.parse(body);

       getFamilyId(user.userid, (err, userFamilyId) => {
        if(err) {
          console.log(err.stack);
          return;
        } else {
            getListOfChildren(userFamilyId, (err, children) => {
              if (!err) {
                res.end(JSON.stringify(children));
              }
            });
          }
       })
     });
    return 1;
   },

  "/UpdatePassword": (req, res, role) => {
    let sessionID = cookie.parse(req.headers.cookie || "").sessionid;

    lookupSession(req, res, sessionID, (validSession, role, user) => {
      if (!validSession) {
        console.log("invalid session trying to edit");
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
        updatePassword(user.userid, data.CurrentPassword, data.NewPassword, data.RepeatPassword, (err) => {
            if (!err) {
              res.end("Request successful");
            }
            });
      });
    });

    return 1;
  },

    "/Addfacilitation": (req, res, role) => {
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
              res.end("Facilitation successfully added");
            }
          });
    });
    return 1;
  },

  "/Deletefacilitation": (req, res, role) => {
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
            res.end("Facilitation successfully deleted");
          }
        });
    });
    return 1;
  },

  "/EditAccountSettings": (req, res, role) => {
    let sessionID = cookie.parse(req.headers.cookie || "").sessionid;

    lookupSession(req, res, sessionID, (validSession, role, user) => {
      if (!validSession) {
        console.log("invalid session trying to edit");
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
        editAccountSettings( user.userid, data.LastName, data.FirstName, data.Phone, (err) => {
            if (!err) {
              res.end("Request successfully added");
            }
            });
      });
    });

    return 1;
  },

  
  "/addNewFacilitator": (req, res, role) => {
   	let sessionID = cookie.parse(req.headers.cookie || "").sessionid;

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
      	console.log(user);
      	getFamilyId(user.userid, (err, userFamilyId) => {
      		if (err) {
      			console.log(err.stack);
      			return;
      		}
      		else{
      			console.log("Entering addFacilitator_user");
      			addNewFacilitator_user(data.FirstName, data.LastName, data.Phone, data.Email, data.Password, userFamilyId, (err) => {
      				if (!err) {
      					res.end("New Facilitator Petition Created Successfully");
      				}
      			});console.log("4444 if");
      		}
      	});
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
		//converting the information given by the user into "data"
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
  
  "/DonateHours": (req, res, role) => {
  	let sessionID = cookie.parse(req.headers.cookie || "").sessionid;
  	//getting the info from the webpage(user)
  	lookupSession(req, res, sessionID, (validSession, role, user) => {
   //checking if the session ID is valid
      if (!validSession) {
        console.log("invalid session trying to sign up");
        return;
      }
	let body = '';
  	req.on("data",(data) => {
  	body += data;
  		if (body.length > 1e6) {
  			req.connection.destroy();
  		}
  	});
  	req.on("end", () => {
  	let data = qs.parse(body);

  	//trying to get the familyId from the user
  	getFamilyId(user.userid, (err, userFamilyId) => {
  		//console.log(userFamilyId);
  		if (err) {
  			console.log(err.stack);
      	return;
  			}	else{
  				//use the familyUnitId obtained into the donate hours function
  				donateHours(userFamilyId, data.Time, data.Family, data.day, data.month, data.year, (err) => {
  				if (!err) {
				res.end("Hours successfully donated");
   			}
  				});
  			}
      	});
   	});
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

	
	"/getfamilies": (req, res, role) => {
    getFamilyNames((err, names) => {
      if (!err) {
        res.end(JSON.stringify(names));
      }
    });
    return 1;
  },


  "/getNewfamilies": (req, res, role) => {
    getNewFamilyNames((err, names) => {
      if (!err) {
        res.end(JSON.stringify(names));
      }
    });
    return 1;
  },

  "/getDonatedWeeklystats": (req, res, role, user) => {
    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });

    req.on("end", () => {
      let data = qs.parse(body);

      getFamilyId(user.userid, (err, userFamilyId) => {
        if (err) {
          console.log(err.stack);
          return;
        } else{
          getDonatedHoursWeekly(userFamilyId, (err, stats) => {
            if (!err) {
              res.end(JSON.stringify(stats));
            }
          });
        }
      });
    });
    return 1;
  },

    "/getReceivedWeeklystats": (req, res, role, user) => {
    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });
    req.on("end", () => {
      let data = qs.parse(body);

      getFamilyId(user.userid, (err, userFamilyId) => {
        if (err) {
          console.log(err.stack);
          return;
        } else{
          getReceivedHoursWeekly(userFamilyId, (err, stats) => {
            if (!err) {
              res.end(JSON.stringify(stats));
            }
          });
        }
      });
    });
    return 1;
  },


  "/getDonatedMonthlystats": (req, res, role, user) => {
    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });

    req.on("end", () => {
      let data = qs.parse(body);

      getFamilyId(user.userid, (err, userFamilyId) => {
        if (err) {
          console.log(err.stack);
          return;
        } else{
          getDonatedHoursMonthly(userFamilyId, (err, stats) => {
            if (!err) {
              res.end(JSON.stringify(stats));
            }
          });
        }
      });
    });
    return 1;
  },

    "/getReceivedMonthlystats": (req, res, role, user) => {
    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });
    req.on("end", () => {
      let data = qs.parse(body);

      getFamilyId(user.userid, (err, userFamilyId) => {
        if (err) {
          console.log(err.stack);
          return;
        } else{
          getReceivedHoursMonthly(userFamilyId, (err, stats) => {
            if (!err) {
              res.end(JSON.stringify(stats));
            }
          });
        }
      });
    });
    return 1;
  },


  "/getDonatedYearlystats": (req, res, role, user) => {
    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });

    req.on("end", () => {
      let data = qs.parse(body);

      getFamilyId(user.userid, (err, userFamilyId) => {
        if (err) {
          console.log(err.stack);
          return;
        } else{
          getDonatedHoursYearly(userFamilyId, (err, stats) => {
            if (!err) {
              res.end(JSON.stringify(stats));
            }
          });
        }
      });
    });
    return 1;
  },

    "/getReceivedYearlystats": (req, res, role, user) => {
    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });
    req.on("end", () => {
      let data = qs.parse(body);

      getFamilyId(user.userid, (err, userFamilyId) => {
        if (err) {
          console.log(err.stack);
          return;
        } else{
          getReceivedHoursYearly(userFamilyId, (err, stats) => {
            if (!err) {
              res.end(JSON.stringify(stats));
            }
          });
        }
      });
    });
    return 1;
  },

   "/getfacilitations": (req, res, role) => {
     let body = '';

     req.on("data", (data) => {
       body += data;
       if (body.length > 1e6) {
         req.connection.destroy();
       }
     });

     req.on("end", () => {
       let data = qs.parse(body);

       getAllFacilitations(data.day, data.month, data.year, (err, facilitations) => {
         if (!err) {
           res.end(JSON.stringify(facilitations));
         }
       });
     });
     return 1;
   }
};

const teacherEndpoints = {
  "/teacher": (req, res, role) => {
    serveFile(req, res, MAIN_PAGE(role));
    return 1;
  },

  "/DaySchedule": (req, res, role) => {
    serveFile(req, res, DAY_PAGE(role));
    return 1;
  },
    "/AccountSettings": (req, res, role) => {
    serveFile(req, res, ACCOUNT_SETTINGS(role));
    return 1;
  },
    "/ChangePassword": (req, res, role) => {
    serveFile(req, res, CHANGE_PASSWORD(role));
    return 1;
  },

    "/Addfacilitation": (req, res, role) => {
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
              res.end("Facilitation successfully added");
            }
          });
    });
    return 1;
  },

  "/Deletefacilitation": (req, res, role) => {
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
            res.end("Facilitation successfully deleted");
          }
        });
    });
    return 1;
  },

    "/UpdatePassword": (req, res, role) => {
    let sessionID = cookie.parse(req.headers.cookie || "").sessionid;

    lookupSession(req, res, sessionID, (validSession, role, user) => {
      if (!validSession) {
        console.log("invalid session trying to edit");
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
        updatePassword(user.userid, data.CurrentPassword, data.NewPassword, data.RepeatPassword, (err) => {
            if (!err) {
              res.end("Request successful");
            }
            });
      });
    });

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


  "/EditAccountSettings": (req, res, role) => {
    let sessionID = cookie.parse(req.headers.cookie || "").sessionid;

    lookupSession(req, res, sessionID, (validSession, role, user) => {
      if (!validSession) {
        console.log("invalid session trying to edit");
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
        editAccountSettings( user.userid, data.LastName, data.FirstName, data.Phone, (err) => {
            if (!err) {
              res.end("Request successfully added");
            }
            });
      });
    });

    return 1;
  },

   "/getfacilitations": (req, res, role) => {
     let body = '';

     req.on("data", (data) => {
       body += data;
       if (body.length > 1e6) {
         req.connection.destroy();
       }
     });

     req.on("end", () => {
       let data = qs.parse(body);

       getAllFacilitations(data.day, data.month, data.year, (err, facilitations) => {
         if (!err) {
           res.end(JSON.stringify(facilitations));
         }
       });
     });
     return 1;
   }
};

const boardEndpoints = {
  "/board": (req, res, role) => {
    serveFile(req, res, MAIN_PAGE(role));
    return 1;
  },
    "/AccountSettings": (req, res, role) => {
    serveFile(req, res, ACCOUNT_SETTINGS(role));
    return 1;
  },
    "/ChangePassword": (req, res, role) => {
    serveFile(req, res, CHANGE_PASSWORD(role));
    return 1;
  },

    "/UpdatePassword": (req, res, role) => {
    let sessionID = cookie.parse(req.headers.cookie || "").sessionid;

    lookupSession(req, res, sessionID, (validSession, role, user) => {
      if (!validSession) {
        console.log("invalid session trying to edit");
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
        updatePassword(user.userid, data.CurrentPassword, data.NewPassword, data.RepeatPassword, (err) => {
            if (!err) {
              res.end("Request successful");
            }
            });
      });
    });

    return 1;
  },

  "/EditAccountSettings": (req, res, role) => {
    let sessionID = cookie.parse(req.headers.cookie || "").sessionid;

    lookupSession(req, res, sessionID, (validSession, role, user) => {
      if (!validSession) {
        console.log("invalid session trying to edit");
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
        editAccountSettings( user.userid, data.LastName, data.FirstName, data.Phone, (err) => {
            if (!err) {
              res.end("Request successfully added");
            }
            });
      });
    });

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

  "/PendingAbsences": (req, res, role) => {
    serveFile(req, res, ABSENCE_LIST_PAGE(role));
    return 1;
  },

  "/AddChild": (req, res, role) => {
    serveFile(req, res, ADD_CHILD(role));
    return 1;
  },

  "/EditFamily": (req, res, role) => {
    serveFile(req, res, EDIT_FAMILY(role));
    return 1;
  },

  "/EditFacilitator": (req, res, role) => {
    serveFile(req, res, EDIT_FACILITATOR(role));
    return 1;
  },

  "/CreateFamily": (req, res, role) => {
    serveFile(req, res, CREATE_FAMILY(role));
    return 1;
  },

  "/ChangePassword": (req, res, role) => {
    serveFile(req, res, CHANGE_PASSWORD(role));
    return 1;
  },

  "/AcceptFacilitator": (req, res, role) => {
    serveFile(req, res, ACCEPT_FACILITATOR(role));
    return 1;
  },
  "/CreateFacilitator": (req, res, role) => {
    serveFile(req, res, CREATE_FACILITATOR(role));
    return 1;
  },
  "/AddFieldTrip": (req, res, role) => {
    serveFile(req, res, ADD_FIELD_TRIP(role));
    return 1;
  },

  "/FieldTrip": (req, res, role) => {
    serveFile(req, res, FIELD_TRIP(role));
    return 1;
  },

  "/AccountSettings": (req, res, role) => {
    serveFile(req, res, ACCOUNT_SETTINGS(role));
    return 1;
  },

  "/EditAccountSettings": (req, res, role) => {
    let sessionID = cookie.parse(req.headers.cookie || "").sessionid;

    lookupSession(req, res, sessionID, (validSession, role, user) => {
      if (!validSession) {
        console.log("invalid session trying to edit");
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
        editAccountSettings( user.userid, data.LastName, data.FirstName, data.Phone, (err) => {
            if (!err) {
              res.end("Request successfully added");
            }
            });
      });
    });

    return 1;
  },



  "/UpdatePassword": (req, res, role) => {
    let sessionID = cookie.parse(req.headers.cookie || "").sessionid;

    lookupSession(req, res, sessionID, (validSession, role, user) => {
      if (!validSession) {
        console.log("invalid session trying to edit");
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
        updatePassword(user.userid, data.CurrentPassword, data.NewPassword, data.RepeatPassword, (err, message) => {
            if (!err) {
              if(message){
                res.end(message);
              } else{
              res.end("Request successful");
              }
              }
            });
      });
    });

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

  "/getNewfamilies": (req, res, role) => {
    getNewFamilyNames((err, names) => {
      if (!err) {
        res.end(JSON.stringify(names));
      }
    });
    return 1;
  },


  "/getWeeklyFamilyStats": (req, res, role) => {
    var famTimes = {};
    var i;
    var diff = 0;
    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });

    req.on("end", () => {
      let data = qs.parse(body);

      getAllFamilyIds((err, FAMS) => {
        if (!err) {
          console.log(FAMS);
          async.each(FAMS, function(fam, cb) {
            getFamilyWeeklyTimes(fam.familyunitid, (err, times) => {
              if (!err) {
                var sum = 0;
                for (var j of times) {
                  diff = calculateHours(j.timestart, j.timeend);
                  sum += diff;
                }
                famTimes[fam.familyunitid] = {name: fam.familyname, totalHours: sum};
                cb(null);
              } else {
                cb(1);
              }
            });
          }, (err) => {
            if (err) {
              console.log("err here");
            } else {
              res.end(JSON.stringify(famTimes));
            }
          });
        }
      });
    });    
    return 1;
  },

  "/getMonthlyFamilyStats": (req, res, role) => {
    var famTimes = {};
    var i;
    var diff = 0;
    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });

    req.on("end", () => {
      let data = qs.parse(body);

      getAllFamilyIds((err, FAMS) => {
        if (!err) {
          console.log(FAMS);
          async.each(FAMS, function(fam, cb) {
            getFamilyMonthlyTimes(fam.familyunitid, (err, times) => {
              if (!err) {
                var sum = 0;
                for (var j of times) {
                  diff = calculateHours(j.timestart, j.timeend);
                  sum += diff;
                }
                famTimes[fam.familyunitid] = {name: fam.familyname, totalHours: sum};
                cb(null);
              } else {
                cb(1);
              }
            });
          }, (err) => {
            if (err) {
              console.log("err here");
            } else {
              res.end(JSON.stringify(famTimes));
            }
          });
        }
      });
    });    
    return 1;
  },

    "/getYearlyFamilyStats": (req, res, role) => {
    var famTimes = {};
    var i;
    var diff = 0;
    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });

    req.on("end", () => {
      let data = qs.parse(body);

      getAllFamilyIds((err, FAMS) => {
        if (!err) {
          console.log(FAMS);
          async.each(FAMS, function(fam, cb) {
            getFamilyYearlyTimes(fam.familyunitid, (err, times) => {
              if (!err) {
                var sum = 0;
                for (var j of times) {
                  diff = calculateHours(j.timestart, j.timeend);
                  sum += diff;
                }
                famTimes[fam.familyunitid] = {name: fam.familyname, totalHours: sum};
                cb(null);
              } else {
                cb(1);
              }
            });
          }, (err) => {
            if (err) {
              console.log("err here");
            } else {
              res.end(JSON.stringify(famTimes));
            }
          });
        }
      });
    });    
    return 1;
  },

  "/getDonatedWeeklystats": (req, res, role) => {
    var donated = {};
    var i;
    var diff = 0;
    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });
    req.on("end", () => {
      let data = qs.parse(body);

      getAllFamilyIds((err, FAMS) => {
        if (!err) {
          async.each(FAMS, function(fam, cb) {
            getDonatedHoursWeekly(fam.familyunitid, (err, stats) => {
              if (!err) {
                donated[fam.familyunitid] = stats;
                cb(null);
              } else {
                cb(1);
              }
            });
          }, (err) => {
            if (err) {
              console.log("err here");
            } else {
              res.end(JSON.stringify(donated));
            }
          });
        }
      });
    });    
    return 1;
  },

  "/getReceivedWeeklystats": (req, res, role) => {
    var received = {};
    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });
    req.on("end", () => {
      let data = qs.parse(body);

      getAllFamilyIds((err, FAMS) => {
        if (!err) {
          async.each(FAMS, function(fam, cb) {
            getReceivedHoursWeekly(fam.familyunitid, (err, stats) => {
              if (!err) {
                received[fam.familyunitid] = stats;
                console.log(stats);
                console.log(received);
                console.log(received[fam.familyunitid]);
                cb(null);
              } else {
                cb(1);
              }
            });
          }, (err) => {
            if (err) {
              console.log("err here");
            } else {
              res.end(JSON.stringify(received));
            }
          });
        }
      });
    });    
    return 1;
  },

  "/getDonatedMonthlystats": (req, res, role) => {
    var donated = {};
    var i;
    var diff = 0;
    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });
    req.on("end", () => {
      let data = qs.parse(body);

      getAllFamilyIds((err, FAMS) => {
        if (!err) {
          async.each(FAMS, function(fam, cb) {
            getDonatedHoursMonthly(fam.familyunitid, (err, stats) => {
              if (!err) {
                donated[fam.familyunitid] = stats;
                cb(null);
              } else {
                cb(1);
              }
            });
          }, (err) => {
            if (err) {
              console.log("err here");
            } else {
              res.end(JSON.stringify(donated));
            }
          });
        }
      });
    });    
    return 1;
  },

  "/getReceivedMonthlystats": (req, res, role) => {
    var received = {};
    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });
    req.on("end", () => {
      let data = qs.parse(body);

      getAllFamilyIds((err, FAMS) => {
        if (!err) {
          async.each(FAMS, function(fam, cb) {
            getReceivedHoursMonthly(fam.familyunitid, (err, stats) => {
              if (!err) {
                received[fam.familyunitid] = stats;
                console.log(stats);
                console.log(received);
                console.log(received[fam.familyunitid]);
                cb(null);
              } else {
                cb(1);
              }
            });
          }, (err) => {
            if (err) {
              console.log("err here");
            } else {
              res.end(JSON.stringify(received));
            }
          });
        }
      });
    });    
    return 1;
  },

  "/getDonatedYearlystats": (req, res, role) => {
    var donated = {};
    var i;
    var diff = 0;
    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });
    req.on("end", () => {
      let data = qs.parse(body);

      getAllFamilyIds((err, FAMS) => {
        if (!err) {
          async.each(FAMS, function(fam, cb) {
            getDonatedHoursYearly(fam.familyunitid, (err, stats) => {
              if (!err) {
                donated[fam.familyunitid] = stats;
                cb(null);
              } else {
                cb(1);
              }
            });
          }, (err) => {
            if (err) {
              console.log("err here");
            } else {
              res.end(JSON.stringify(donated));
            }
          });
        }
      });
    });    
    return 1;
  },

  "/getReceivedYearlystats": (req, res, role) => {
    var received = {};
    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });
    req.on("end", () => {
      let data = qs.parse(body);

      getAllFamilyIds((err, FAMS) => {
        if (!err) {
          async.each(FAMS, function(fam, cb) {
            getReceivedHoursYearly(fam.familyunitid, (err, stats) => {
              if (!err) {
                received[fam.familyunitid] = stats;
                console.log(stats);
                console.log(received);
                console.log(received[fam.familyunitid]);
                cb(null);
              } else {
                cb(1);
              }
            });
          }, (err) => {
            if (err) {
              console.log("err here");
            } else {
              res.end(JSON.stringify(received));
            }
          });
        }
      });
    });    
    return 1;
  },

  "/getRooms": (req, res, role) => {
    getRoomInfo((err, rooms) => {
      if (!err) {
        res.end(JSON.stringify(rooms));
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

  "/getabsencelist": (req, res, role) => {
    getAbsences((err, absences) => {
      if(!err) {
        res.end(JSON.stringify(absences));
      }
    });
    return 1;
  },

  "/Addfacilitation": (req, res, role) => {
    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });

    req.on("end", () => {
      let data = qs.parse(body);
		//We have to check if the same person registers for the same time twice or + times
      insertFacilitation(data.Facilitator, data.roomid, data.StartTime,
          data.EndTime, data.day, data.month, data.year, (err) => {
            if (!err) {
              res.end("Facilitation successfully added");
            }
          });
    });
    return 1;
  },

  "/Deletefacilitation": (req, res, role) => {
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
            res.end("Facilitation successfully deleted");
          }
        });
    });
    return 1;
  },

  "/Createfamily": (req, res, role) => {
    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });

    req.on("end", () => {
      let data = qs.parse(body);
      createFamily(data.FamilyName, (err) => {
        if (!err) {
          res.end("Family Successfully Created");
        }
      });
    });
    return 1;
  },

  "/Familyedit": (req, res, role) => {
    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });

    req.on("end", () => {
      let data = qs.parse(body);
      editFamily(data.FamilyName, data.Family, (err) => {
        if (!err) {
          res.end("Family Name Successfully Edited");
        }
      });
    });
    return 1;
  },

  "/addChild": (req, res, role) => {
    let body = '';
    req.on("data", (data) => {
      body += data;
      if (body.length > 1e6) {
        req.connection.destroy();
      }
    });

    req.on("end", () => {
      let data = qs.parse(body);
      addChild(data.FirstName, data.LastName, data.Family, data.Room, (err) => {
        if (!err) {
          res.end("Child Successfully Added");
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
   },

   "/getfacilitations": (req, res, role) => {
     let body = '';

     req.on("data", (data) => {
       body += data;
       if (body.length > 1e6) {
         req.connection.destroy();
       }
     });

     req.on("end", () => {
       let data = qs.parse(body);

       getAllFacilitations(data.day, data.month, data.year, (err, facilitations) => {
         if (!err) {
           res.end(JSON.stringify(facilitations));
         }
       });
     });
     return 1;
   },
   
   "/addNewFacilitator": (req, res, role) => {
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
      	addNewUser(data.FirstName, data.LastName, data.Phone, data.Email, data.Password, (err) => {
        		if (err){
        			console.log(err.stack);
      			return;
      		}
      	});
        	getUserId(data.FirstName, data.LastName, (err, userId) => {
  				if (err) {
  					console.log(err.stack);
      			return;
  				}
  				else{
  					addNewFacilitator_admin(userId, data.Family, (err) => {
  						if (!err){
  							res.end("New User Successfully Added");
  						}
        			});
				}
      	});
		})
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

function getNewFamilyNames(callback) {
  db.query(`SELECT familyname, familyunitid FROM familyunits`, (err, res) => {
      if (err) {
        console.log(err.stack);
        callback(true);
      } else {
        callback(null, res.rows);
      }
    });
}

function getFamilyWeeklyTimes(famid, callback) {
  console.log(famid);
  var curr = new Date;
  var firstday = new Date(curr.setDate(curr.getDate() - curr.getDay()));
  var lastday = new Date(curr.setDate(curr.getDate() - curr.getDay()+6));
  console.log("THIS IS FIRST AND LAST DAY");
  console.log(firstday.getDate(), lastday.getDate());
  console.log(firstday.getMonth(), lastday.getMonth());
  console.log(firstday.getFullYear(), lastday.getFullYear());
  console.log("-------");
  db.query(`SELECT timestart, timeend FROM facilitations, familymembers WHERE familymembers.userid = facilitations.userid AND familyunitid=${famid} AND day BETWEEN ${firstday.getDate()} AND ${lastday.getDate()} AND month BETWEEN ${firstday.getMonth()+1} AND ${lastday.getMonth()+1} AND year BETWEEN ${firstday.getFullYear()} AND ${lastday.getFullYear()}`, (err, res) => {
    if (err) {
        console.log(err.stack);
        callback(true);
      } else {
        callback(null, res.rows);
      }
    });
}

function getFamilyMonthlyTimes(famid, callback) {
  var curr = new Date;
  var firstday = new Date(curr.setDate(curr.getDate() - curr.getDay()));
  var lastday = new Date(curr.setDate(curr.getDate() - curr.getDay()+6));
  console.log("THIS IS FIRST AND LAST DAY");
  console.log(firstday.getDate(), lastday.getDate());
  console.log(firstday.getMonth(), lastday.getMonth());
  console.log(firstday.getFullYear(), lastday.getFullYear());
  console.log("-------");
  db.query(`SELECT timestart, timeend FROM facilitations, familymembers WHERE familymembers.userid = facilitations.userid AND familyunitid=${famid} AND day BETWEEN ${firstday.getDate()} AND ${lastday.getDate()} AND month BETWEEN ${firstday.getMonth()+1} AND ${lastday.getMonth()+1}`, (err, res) => {
    if (err) {
        console.log(err.stack);
        callback(true);
      } else {
        callback(null, res.rows);
      }
    });
}

function getFamilyYearlyTimes(famid, callback) {
  var curr = new Date;
  var firstday = new Date(curr.setDate(curr.getDate() - curr.getDay()));
  var lastday = new Date(curr.setDate(curr.getDate() - curr.getDay()+6));
  console.log("THIS IS FIRST AND LAST DAY");
  console.log(firstday.getDate(), lastday.getDate());
  console.log(firstday.getMonth(), lastday.getMonth());
  console.log(firstday.getFullYear(), lastday.getFullYear());
  console.log("-------");
  db.query(`SELECT timestart, timeend FROM facilitations, familymembers WHERE familymembers.userid = facilitations.userid AND familyunitid=${famid} AND day BETWEEN ${firstday.getDate()} AND ${lastday.getDate()}`, (err, res) => {
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

function getRoomInfo(callback) {
  db.query(`SELECT roomid, colour FROM rooms`, (err, res) => {
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

function createFamily(AddfamilyName, callback){
  db.query(`INSERT INTO familyunits (familyName) VALUES('${AddfamilyName}')`,
    (err) => {
      if(err) {
        console.log(err.stack);
        callback(true);
      } else {
        callback(null);
      }
    });
}

function updatePassword(userId, CurrentPassword, NewPassword, RepeatPassword, callback){
  console.log(userId);
  console.log(CurrentPassword);
  console.log(NewPassword);
  console.log(RepeatPassword);
  if (NewPassword == RepeatPassword){
  db.query(`UPDATE users SET pword = '${NewPassword}' WHERE userid = ${userId} AND pword='${CurrentPassword}'`,
    (err) => {
      if(err) {
        console.log(err.stack);
        callback(true);
      } else {
        callback(null);
      }
    });
  } else {
    callback(null, "Non-Matching Passwords");
  }
}


function editFamily(newfamilyname, familyunitid, callback){
  db.query(`UPDATE familyUnits SET familyName = '${newfamilyname}' WHERE familyUnitID = ${familyunitid}`,
    (err) => {
      if(err) {
        console.log("error in editFamily");
        console.log(newfamilyname);
        console.log(familyunitid);
        console.log(err.stack);
        callback(true);
      } else {
        callback(null);
      }
    });
}

function addChild(first, last, family, room, callback){
  db.query(`INSERT INTO Children (familyunitid, firstname, lastname, roomid) VALUES (${family}, '${first}', '${last}', ${room})`,
    (err) => {
      if(err) {
        console.log(first);
        console.log(last);
        console.log(family);
        console.log(room);

        console.log(err.stack);
        callback(true);
      } else {
        callback(null);
      }
    });
}

function getDonatedHoursWeekly(familyunitid, callback){
  console.log()
  var curr = new Date;
  var firstday = new Date(curr.setDate(curr.getDate() - curr.getDay()));
  var lastday = new Date(curr.setDate(curr.getDate() - curr.getDay()+6));
  db.query(`SELECT SUM(hours) AS donatedSum FROM Donations WHERE fromid=${familyunitid} AND day BETWEEN ${firstday.getDate()} AND ${lastday.getDate()} AND month BETWEEN ${firstday.getMonth()+1} AND ${lastday.getMonth()+1} AND year BETWEEN ${firstday.getFullYear()} AND ${lastday.getFullYear()}`,
    (err, result) => {
      if (err) {
        console.log(err.stack);
        callback(true);
      } else {
        console.log("TESTING FOR HOURS");
        callback(null, result.rows);
      }
    });
}

function getReceivedHoursWeekly(familyunitid, callback){
  var curr = new Date;
  var firstday = new Date(curr.setDate(curr.getDate() - curr.getDay()));
  var lastday = new Date(curr.setDate(curr.getDate() - curr.getDay()+6));
  db.query(`SELECT SUM(hours) AS receivedSum from Donations WHERE toid=${familyunitid} AND day BETWEEN ${firstday.getDate()} AND ${lastday.getDate()} AND month BETWEEN ${firstday.getMonth()+1} AND ${lastday.getMonth()+1} AND year BETWEEN ${firstday.getFullYear()} AND ${lastday.getFullYear()}`,
    (err, result) => {
      if (err) {
        console.log(err.stack);
        callback(true);
      } else {
        callback(null, result.rows);
      }
    });
}

function getTotalHoursWeekly(callback){
  var curr = new Date;
  var firstday = new Date(curr.setDate(curr.getDate() - curr.getDay()));
  var lastday = new Date(curr.setDate(curr.getDate() - curr.getDay()+6));
  db.query(`SELECT SUM(hours) AS totalHours from Donations`,
    (err, result) => {
      if (err) {
        console.log(err.stack);
        callback(true);
      } else {
        callback(null, result.rows);
      }
    });
}


function getDonatedHoursMonthly(familyunitid, callback){
  console.log()
  var curr = new Date;
  var firstday = new Date(curr.setDate(curr.getDate() - curr.getDay()));
  var lastday = new Date(curr.setDate(curr.getDate() - curr.getDay()+6));
  db.query(`SELECT SUM(hours) AS donatedSum FROM Donations WHERE fromid=${familyunitid} AND month BETWEEN ${firstday.getMonth()+1} AND ${lastday.getMonth()+1} AND year BETWEEN ${firstday.getFullYear()} AND ${lastday.getFullYear()}`,
    (err, result) => {
      if (err) {
        console.log(err.stack);
        callback(true);
      } else {
        console.log("TESTING FOR HOURS");
        callback(null, result.rows);
      }
    });
}

function getReceivedHoursMonthly(familyunitid, callback){
  var curr = new Date;
  var firstday = new Date(curr.setDate(curr.getDate() - curr.getDay()));
  var lastday = new Date(curr.setDate(curr.getDate() - curr.getDay()+6));
  db.query(`SELECT SUM(hours) AS receivedSum from Donations WHERE toid=${familyunitid} AND month BETWEEN ${firstday.getMonth()+1} AND ${lastday.getMonth()+1} AND year BETWEEN ${firstday.getFullYear()} AND ${lastday.getFullYear()}`,
    (err, result) => {
      if (err) {
        console.log(err.stack);
        callback(true);
      } else {
        callback(null, result.rows);
      }
    });
}

function getDonatedHoursYearly(familyunitid, callback){
  console.log()
  var curr = new Date;
  var firstday = new Date(curr.setDate(curr.getDate() - curr.getDay()));
  var lastday = new Date(curr.setDate(curr.getDate() - curr.getDay()+6));
  db.query(`SELECT SUM(hours) AS donatedSum FROM Donations WHERE fromid=${familyunitid} AND year BETWEEN ${firstday.getFullYear()} AND ${lastday.getFullYear()}`,
    (err, result) => {
      if (err) {
        console.log(err.stack);
        callback(true);
      } else {
        console.log("TESTING FOR HOURS");
        callback(null, result.rows);
      }
    });
}

function getReceivedHoursYearly(familyunitid, callback){
  var curr = new Date;
  var firstday = new Date(curr.setDate(curr.getDate() - curr.getDay()));
  var lastday = new Date(curr.setDate(curr.getDate() - curr.getDay()+6));
  db.query(`SELECT SUM(hours) AS receivedSum from Donations WHERE toid=${familyunitid} AND year BETWEEN ${firstday.getFullYear()} AND ${lastday.getFullYear()}`,
    (err, result) => {
      if (err) {
        console.log(err.stack);
        callback(true);
      } else {
        callback(null, result.rows);
      }
    });
}
function getAbsences(callback){
  db.query(`SELECT absenceid, familyname, todate, fromdate from Absences, familyunits WHERE familyunits.familyunitid = Absences.familyunitid AND status = 1`,
    (err, result) => {
      if (err) {
        console.log(err.stack);
        callback(true);
      } else {
        callback(null, result.rows);
      }
    });
}

function getFamStats(famID, callback){
    db.query(`SELECT timestart, timeend, day, month, year FROM facilitations, familymembers WHERE facilitations.userid = familymembers.userid AND familymembers.familyunitid = ${famID}`,
    (err, result) => {
      if (err) {
        console.log(err.stack);
        callback(true);
      } else {
        callback(null, result.rows);
      }
    });
}

function requestAbsence( userId, fromDate, toDate, callback){
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

function editAccountSettings( userId, LastName, FirstName, Phone, callback){
  db.query(`UPDATE users SET firstname = '${FirstName}', lastname = '${LastName}', phone = '${Phone}' WHERE userId = '${userId}'`,
    (err) => {
      if(err) {
        console.log(err.stack);
        callback(true);
      } else {
        callback(null);
      }
    });
}

function approveAbsence(absenceId, callback) {
	db.query(`UPDATE absences set status = 2 WHERE absenceId = ${absenceId}`, (err) => {
    if (err) {
      console.log(err.stack);
      callback(true);
    } else {
      callback(null);
    }
  });
}

function denyAbsence(absenceId, callback) {
	db.query(`UPDATE absences set status = 0 WHERE absenceId = ${absenceId}`, (err) => {
   if (err) {
      console.log(err.stack);
      callback(true);
    } else {
      callback(null);
    	}
  	});
}

//Getting and returning the familyUnitId from the table using the userid
function getFamilyId (userId, callback){
	db.query(`SELECT familyUnitId from familyMembers where userId = '${userId}'`, (err, res) => {
   if (err) {
      console.log(err.stack);
      callback(true);
   }	else {
      callback(null, res.rows[0].familyunitid);
		}
   });
}

function getAllFamilyIds (callback){
  db.query(`select DISTINCT familyunits.familyunitid, familyname from familymembers, familyunits WHERE familyunits.familyunitid = familymembers.familyunitid`, (err, res) => {
   if (err) {
      console.log(err.stack);
      callback(true);
   }  else {
      callback(null, res.rows);
    }
   });
}

//Updating the weekly hours for the donating family and the recieving family
function donateHours(donatingFamilyId, Time, targetFamilyId, day, month, year, callback) {
	console.log("Donating Hours");
	//Substract the things from the donating family
   db.query(`INSERT INTO Donations (fromid, toid, hours, day, month, year) VALUES (${donatingFamilyId},${targetFamilyId},${Time},${day},${month},${year})`, (err) => {
   if (err) {
   	  console.log(err.stack);
      callback(true);
   } 	else {
      callback(null);
			}
	});
}

//Function used by admin to create a new user
function addNewUser(firstName, lastName, phone, email, password, callback) {
	db.query(`INSERT INTO users (firstname, lastname, phone, email, pword) VALUES('${firstName}', '${lastName}', '${phone}', '${email}', '${password}')`,
	(err) => 
	{
      if(err) {
        console.log(err.stack);
        callback(true);
      } else {
        callback(null);
      }
    });
}

//Function used to get the userId of any user using its email
function getUserId(firstName, lastName, callback) {

	db.query(`SELECT userid FROM users WHERE (firstname = '${firstName}' AND lastname = '${lastName}')`, (err, res) => {
	if (err) {
      console.log(err.stack);
      callback(true);
   }	else {
   	//console.log(res.rows[0].userid)
      callback(null, res.rows[0].userid);
		}
   });
}

//Function used to add new facilitator
function addNewFacilitator_admin (userId, familyUnitId, callback) {
	db.query(`INSERT INTO familymembers (userid, familyunitid) VALUES(${userId}, ${familyUnitId})`,
	(err) => {
   if(err) {
   	console.log(err.stack);
      callback(true);
   }	else {
   	callback(null);
      }
   });
}

//Function used by the user to add a new facilitator
function addNewFacilitator_user (firstName, lastName, phone, email, password, familyUnitId, callback) {
	db.query(`INSERT INTO pendingfacilitators (firstname, lastname, phone, email, pword, familyUnitId) VALUES('${firstName}', '${lastName}', '${phone}', '${email}', '${password}', ${familyUnitId})`,
	(err) => {
      if(err) {
      	console.log("1 if");
      	console.log(err.stack);
      	callback(true);
      } else {
        callback(null);
      }
      console.log("123123123 if");
    });
}

function getAllFacilitations(day, month, year, callback) {
  db.query(`SELECT firstname, lastname, roomid, users.userid, timestart, timeend FROM facilitations, users WHERE users.userid = facilitations.userid AND day = ${day} AND month = ${month} AND year = ${year} AND NOT timestart = '' AND NOT timeend = ''`, (err, res) => {
    if (err) {
      console.log(err.stack);
      callback(true);
    } else {
      callback(null, res.rows);
    }
  });
}

function getNextFacilitations(userid, day, month, year, callback) {
  db.query(`SELECT firstname, lastname, roomid, users.userid, timestart, timeend, day, month, year FROM facilitations, users WHERE users.userid = facilitations.userid AND users.userid=${userid} AND day BETWEEN ${day} AND ${day}+5 AND month = ${month} AND year = ${year} AND NOT timestart = '' AND NOT timeend = '' ORDER BY day,month,year LIMIT 5`, (err, res) => {
    if (err) {
      console.log(err.stack);
      callback(true);
    } else {
      console.log(res.rows);
      callback(null, res.rows);
    }
  });
}

function getListOfChildren(familyunitid, callback) {
  db.query(`SELECT firstname, lastname, roomid FROM Children WHERE familyunitid = ${familyunitid}`, (err, res) => {
    if(err) {
      console.log(err.stack);
      callback(true);
    } else {
      callback(null, res.rows);
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


function calculateHours(timestart, timeend){
    var Start = new Date("01/01/2018 " + timestart);
    var End = new Date("01/01/2018 " + timeend);

    var Diff = (End - Start)/(1000*60*60);
    return Diff;
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

function handleEndpoint(req, res, endpoint, role, user) {
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
        status = adminEndpoints[endpoint](req, res, role, user);
      }
      break;
    case "board":
      if (endpoint in boardEndpoints) {
        status = boardEndpoints[endpoint](req, res, role, user);
      }
      break;
    case "teacher":
      if (endpoint in teacherEndpoints) {
        status = teacherEndpoints[endpoint](req, res, role, user);
      }
      break;
    case "user":
      if (endpoint in userEndpoints) {
        status = userEndpoints[endpoint](req, res, role, user);
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
    lookupSession(req, res, sessionID, (validSession, role, user) => {
      if (validSession) {
        handleEndpoint(req, res, endpoint, role, user);
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
