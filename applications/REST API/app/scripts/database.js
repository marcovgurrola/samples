/*****************************************************************************/
// Module for Database functionality
/*****************************************************************************/

// Import modules and or files
var pg = require('pg');
var cons = require('./constants');

function execQuery(conString, strQuery, callback) {
  try {

    // Obtain a database connection from postgres connection pool
    pg.connect(conString, function(err, client, done) {
      var handleError = function(err) {
        // Without error, continue with request
        if(!err) return false;

        // Error occurred, remove client from the connection pool
        if(client){
          done(client);
        }
        return true;
      };

      // Handles postgress error
      if(handleError(err)) callback(cons.DATABASE_ERROR);

      // Get results from custom query
      var query = client.query(strQuery);

      // Handles query error
      query.on('error', function(error) {
        if(handleError(error)) callback(cons.QUERY_ERROR);
      });

      query.on('row', function(row, result) {
        result.addRow(row);
      });

      query.on('end', function(result) {
        console.log('Query result: %s item(s)', result.rows.length);
        callback({count: result.rows.length, date: new Date(), items: result.rows});
      });
        
      // Return the connection to the pool for other requests to reuse
      done();
    });
  }
  catch(error){
    callback('Error related to database functionality: ' + error);
  }
}

exports.execQuery = execQuery;