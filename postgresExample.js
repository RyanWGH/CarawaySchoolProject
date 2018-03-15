// All my attempts to connect the server to the databse failed. Whenever I used a tutorial and
// followed it and error would occur from node_modules/pg/lib/connection.js
//
// Specifically, on line 289 "var emptyBuffer = Buffer.alloc(0)" it wouldn't tell me why this caused 
// an error and I couldn't figure it out. 
//
// The following link has one of the most simple yet comphrensive examples I came accross for both 
// connecting to the database and implementing queries. 
//	https://www.wlaurance.com/2016/03/node.js-postgresql-example/






// Note: when looking into making a CRUD application with Node.js, Express seems really common in 
// making a server connection. Since server.js already has listenAndServe(8080) I don't think we need 
// to implement Express but if an issue with that occurs it looks like it's an alternative.

function buildSelectQuery(tableName) {
  return ['select * from', tableName].join(' ');
}

function selectAll(tableName) {
  return function(onSelectReturn) {
    var sql = buildSelectQuery(tableName);
    var queryClient = buildQueryClient(sql);
    queryClient(function(err, tableValues) {
      if (err) {
        return onSelectReturn(new Error(['Select all failed on', tableName, 'with error', err.toString()].join(' ')));
      } else {
        return onSelectReturn(null, tableValues);
      }
    });
  }
}

var errorCheck = function(cb) {
  return function(err, result) {
    if (err) {
      console.error(err);
      throw err;
    } else {
      cb(result);
    }
  }
}

var printRows = function(text) {
  return errorCheck(function(results) {
    console.log(results.rows);
    if (text) console.log(text);
  });
}

var selectAllRooms = selectAll('rooms');
selectAllRooms(printRows());



var selectAtMostNUsers = buildDynamicQuery([
  'select * from users',
  'limit $1'
]);
var selectAtMost5Users = selectAtMostNUsers(5);
selectAtMost5Users(printRows('Select at most 5 users'));



var getUserPassword = buildDynamicQuery([
  "select pword from users",
  "where userId like '$1'"
]);

var getSpecificUserPassword = getUserPassword(4);
getUserPassword(4)(errorCheck(function(result){
  console.log(result.rows[0]);
}));
