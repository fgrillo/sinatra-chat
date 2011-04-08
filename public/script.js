function update() {
  read();
  setTimeout(update, 3000);
}

function read() {
  $.ajax( {
    type: "GET",
    url:  "/read?last_msg="+$('#msg_number').val(),
    success: function(data) {
      var rsp = JSON.parse(data);
      $('#msg_number').val(rsp.msgsize);
      var today = new Date();
      for (i = 0 ; i < rsp.msgs.length ; i++ ) {
        msg = today.getHours() + ':' + today.getMinutes() + ':' + today.getSeconds() + ' - ' + rsp.msgs[i][0] + ': ';
        s = $("<strong></strong>").append(msg);
        p = $("<p></p>").attr('class','msg-line').append(s);
        p.append(rsp.msgs[i][1]);
        $('#msgs').prepend(p);
        p.fadeOut('fast');
        p.fadeIn('fast');
      }
    }
  } );
}

function post() {
  $.ajax( {
    type: "POST",
    url:  "/post?message="+$('#message').val(),
    success: function() {
      $('#message').val('');
    }
  } );
  read();
}

$(document).ready(function() {
  $('#message').keypress(function(event) {
    if (event.keyCode ==  '13') {
      post();
    }
  });
  update();
  jQuery.fx.off = false;
});
