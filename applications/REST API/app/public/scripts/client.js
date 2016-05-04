/*****************************************************************************/
// GUI Client functionality
/*****************************************************************************/
$(document).ready(function(){

  if(typeof(Storage) === "undefined")
  console.log("Sorry, your browser does not support web storage");

  // ------------------------ Getters/setters/sessions ------------------------
  // Update Option (last or all requests)
  function setUpdateOption() {
    sessionStorage['updateOption'] = ($('#updateOpt').val());
  }
  $('#updateOpt').click(function(){
    setUpdateOption();
  });
  function getUpdateOption() {
    return sessionStorage['updateOption'];
  }
  // Last request sent
  function setLastSubmit(data) {
    sessionStorage['lastSubmit'] = data;
  }
  function getLastSubmit() {
    return sessionStorage['lastSubmit'];
  }
  // Last json displayed
  function setJSONText(data) {
    sessionStorage['JSONText'] = data;
  }
  function getJSONText() {
    return sessionStorage['JSONText'];
  }



  // ------------------- Restoring last values on controls --------------------
  if(getUpdateOption())
    $('#updateOpt').val(getUpdateOption());

  if(getLastSubmit()) {
    var arr = getLastSubmit().split(',');
    $('#query_type').val(arr[0]);
    if(arr[1] !== undefined)
      $('#filter').val(arr[1]);
  }

  if(getJSONText())
    $('#jsonTxt').text(getJSONText());



  // ----------------- Sends request to get available surveys -----------------
  $('form').submit(function(e){
    e.preventDefault();
    var data = '';

    // Set the request by type and filter
    if($('#query_type').val() === 'surveys')
      data = 'surveys';
    else if($('#filter').val().length > 0)
      data = $('#query_type').val() +','+ $('#filter').val();

    if(data.length > 0) {
      setLastSubmit(data);
      setUpdateOption();

      socket.emit('surveys', data);
    }
  });



  // -------------------- Socket creation and other events --------------------
  // Attempts to connect to the server
  var socket = io.connect('http://' + window.location.host + ':80');

  // Raised on connection event, send salutation
  socket.on('connect', function(data) {
    socket.emit('join', 'Hello from client');
  });

  // Displays welcome message from server
  socket.on('welcome', function(data) {
    $('#conn_status').html(data);
  });

  // Gets and Displays available surveys info, without submit
  socket.on('available', function(data) {
    //console.log(JSON.stringify(data));

    if(getUpdateOption() === 'last') {
      if(data.requested === getLastSubmit()) {
        data = JSON.stringify(data, undefined, 2);
        formatJSON('jsonTxt', data, false);
      }
    }
    else {
      data = JSON.stringify(data, undefined, 2);
      formatJSON('jsonTxt', data, true);
    }
  });

  /*
  $('#unsubscribe').click(function(){
      socket.emit('unsubscribe');
  });
  */

  // Displays the received data in a friendly form
  function formatJSON(id, input, append) {
    var pre = document.getElementById(id);

    if(append)
      pre.innerHTML += input;
    else {
      //pre.hidden = true;
      pre.innerHTML = input;
      //pre.hidden = false;
    }

    //storing in session
    setJSONText(pre.innerHTML);
  }
});