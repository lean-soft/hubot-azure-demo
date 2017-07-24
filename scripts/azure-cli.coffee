# Description:
#   Allows hubot to run commands using azure-cli.
#
# Dependencies:
#   azure-cli installed in your $PATH
#
# Configuration:
#   This script authenticates using a readonly service principal.
#   https://docs.microsoft.com/en-us/azure/xplat-cli-connect
#
#   The following environment variables are required:
#   HUBOT_AD_APP_ID (Registered Application ID)
#   HUBOT_AD_AUTH_KEY (Registered Application Authentication Key)
#   HUBOT_AD_TENANT_ID (Registered Application Tenant ID)
#
# Author:
#   ericksond
#

exec = require('child_process').exec

execCommand = (msg, cmd) ->
  @maxBuffer = 1024*1024
  options =
    'maxBuffer': @maxBuffer
  exec cmd, options, (error, stdout, stderr) ->
    #msg.send error if error
    console.log error if error
    msg.send stdout
    #msg.send stderr if stderr
    console.log stderr if stderr

  checkAzure = "which azure"
  exec checkAzure, (error, stdout, stderr) ->
    if stdout == "" or stdout is "azure not found"
      console.log "WARN: you don't have azure in your $PATH"

module.exports = (robot) ->
  appId = process.env.HUBOT_AD_APP_ID
  appAuthKey = process.env.HUBOT_AD_AUTH_KEY
  appTenantId = process.env.HUBOT_AD_TENANT_ID

  robot.hear /azure auth$/i, (msg) ->
    command = "azure login -u #{appId} -p #{appAuthKey} --service-principal --tenant #{appTenantId}"

    execCommand msg, command
  
  robot.hear /azure group list$/i, (msg) ->
    command = "azure group list"

    execCommand msg, command
