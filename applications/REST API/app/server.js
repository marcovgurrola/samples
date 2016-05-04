/*****************************************************************************/
// Server functionality
/*****************************************************************************/

// Import modules and or files
var express = require('express');
var app = express();
var server = require('http').createServer(app);
var io = require('socket.io')(server);

var cf = require('./config');
var cons = require('./scripts/constants');
var db = require('./scripts/database');

try {
  var subscriptions = {};
  var publishers = [];
  //var staticPath = __dirname;

  app.use(express.static('public'));

  server.listen(cf.PORT, function() {
    this.setMaxListeners(cf.MAX_LISTENERS);
    console.log('Server listening http://localhost:%s', server.address().port);
  });




  /*----------------- Simple Requests for any type of client ----------------*/
  // Responds a GET request for the homepage
  app.get('/', function(req, res) {
    logRequest(req);
    res.write(cons.WELCOME_MESSAGE);
    res.end();
  });


  // Responds a GET request for Surveys page
  app.get('/surveys', function(req, res) {
    logRequest(req);
    getAvailableSurveys(cons.ALL_SURVEYS, null, function(result) {
      sendResponse(res, result);
    });
  });


  // Responds a GET request for Surveys per subject page
  app.get('/surveys/subject/:value', function(req, res) {
    var value = req.params.value.substr(1, req.params.value.length);

    logRequest(req);
    getAvailableSurveys(cons.BY_SUBJECT, value, function(result) {
      sendResponse(res, result);
    });
  });


  // Responds a GET request for Surveys per party page
  app.get('/surveys/party/:name', function(req, res) {
    var name = req.params.name.substr(1, req.params.name.length);
    
    logRequest(req);
    getAvailableSurveys(cons.BY_PARTY, name, function(result) {
      sendResponse(res, result);
    });
  });


  // Send the http response
  function sendResponse(res, data) {
    if(data === cons.QUERY_ERROR || data === cons.DATABASE_ERROR) {
      res.writeHead(500, {'content-type': 'text/plain'});
      res.end('An error occurred:' + data);
    }
    else {
      res.writeHead(200, {'content-type': 'application/json'});
      res.end(JSON.stringify(data, null, ' '));
    }
  }




  /*---------------------- Requests with Subscriptions ----------------------*/
  // Responds a GET request for the browser client
  app.get('/fancy', function(req, res, next) {
    logRequest(req);
    res.sendFile(__dirname + '/fancy.html');
  });


  //server.on(connection for stateless routes
  io.on('connect', function(client) {  
    console.log('%s arrived, %s clients', client.id, io.engine.clientsCount);

    // Welcome message to client
    client.on('join', function(data) {
      client.emit('welcome', 'Joined ' + new Date());
    });

    // Request for survey data availability
    client.on('surveys', function(data) {
      var arr = data.split(',');

      console.log('Client %s subscribed: %s', client.id, data);

      // Add the survey request to the list of subbcriptions
      client.join(data);
      if(subscriptions[data] !== data) {
          subscriptions[data] = data;
          var publisher = buildPublisher(data);
          publishers.push(publisher);
      }
      console.log(subscriptions[data]);

      getAvailableSurveys(arr[0], arr[1], function(result) {
        client.emit('available', {requested: data, result: result});
      });
    });


    //Client Disconnection event
    client.on('disconnect', function(){
      console.log('A client quit, connections:%s', io.engine.clientsCount);
    });

    /*
    // Unsubscribe request, leave autoupdate of available surveys
    client.on('unsubscribe', function(){
      //Object.keys(io.sockets.connected[client.id].rooms).length;
      for(key in subscriptions){
        client.leave(key);
        console.log('Client %s unsubscribed from %s', client.id, key);
      }
      client.disconnect();
      console.log(io.sockets.connected[client.id].rooms);
    });
    */
  });




  /*------------- Auto publication creation and execution call --------------*/
  function executePublishers() {
    for (var i = 0; i < publishers.length; i++){
      publishers[i]();
    }
  }

  function buildPublisher(data){
    return function() {
        var arr = data.split(',');

        getAvailableSurveys(arr[0], arr[1], function(result) {
          var packet = {requested: data, result: result};
          console.log('Published %s: %s', data, result.count);
          io.to(data).emit('available', packet);
        });
    }
  }

  // Now call above function every x seconds
  setInterval(executePublishers, cf.PUBLISH_INT);




  /*-------------------------------------------------------------------------*/

  // Get available data on request
  function getAvailableSurveys(type, filter, callback) {
    if(type === cons.ALL_SURVEYS) {
      db.execQuery(cf.CONN_STRING, cons.SURVEYS_QUERY, function(data) {
        callback(data);
      });
    }
    if(type === cons.BY_SUBJECT) {
      db.execQuery(cf.CONN_STRING, cons.SURVEYS_QUERY +
        cons.SUBJECT_COND + filter + "';", function(data) {
          callback(data);
      });
    }
    if(type === cons.BY_PARTY) {
      db.execQuery(cf.CONN_STRING, cons.SURVEYS_QUERY +
        cons.PARTY_COND + filter + "%');", function(data) {
          callback(data);
      });
    }
  }


  // Log request details
  function logRequest(req) {
    var strReq = req['method'] + ' '  + req['url'];
    console.log(strReq);
    console.log(JSON.stringify(req['headers'], null, ' '));
  }
}
catch(error) {
  console.log('Error related to server functionality: ', error);
}