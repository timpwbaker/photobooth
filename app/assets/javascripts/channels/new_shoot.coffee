App.shoot_status = App.cable.subscriptions.create "ShootStatusChannel",
  connected: ->
    console.log("connected")

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $("html").removeClass(data["remove_background"]);
    $("html").addClass(data["background"]);
    $("html").removeClass("image");
    $(".status").removeClass("status-center");
    $(".config-top-right").hide();
    $(".status").addClass("status-left");
    $(".status").css({fontSize: data["font_size"]});
    $(".status").text(data["status"]);
    $(".secondary-status").text(data["secondary_status"]);
