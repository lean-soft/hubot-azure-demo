module.exports = (robot) ->
   robot.hear /greet/i, (res) ->
     res.send "Hello,My Master"

