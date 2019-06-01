App.shoot_status = App.cable.subscriptions.create "ShootStatusChannel",
  connected: ->
    console.log("connected")

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $("html").addClass("red");
    $("html").removeClass("image");
    $(".status").removeClass("status-center");
    $(".status").addClass("status-left");
    $(".status").text(data["status"])
