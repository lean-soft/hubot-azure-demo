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

 
module.exports = (robot) ->
  appId = process.env.HUBOT_AD_APP_ID || "jackyzhou@lean-soft.cn"
  appAuthKey = process.env.HUBOT_AD_AUTH_KEY || "change to your password"
  appTenantId = process.env.HUBOT_AD_TENANT_ID || "change to your talentid"
 
  resourcegroup = "docker-beijing-jackyzhou-training-255-stu1"
  machines=["operation","test","swarm-master-0","swarm-node-0","swarm-node-1"]

  robot.respond /环境 认证$/i, (msg) ->
    command = "az login -u #{appId} -p #{appAuthKey}"
    @maxBuffer = 1024*1024
    options =
     'maxBuffer': @maxBuffer
    exec command, options, (error, stdout, stderr) ->
        #msg.send error if error
        console.log error if error
        data = JSON.parse stdout
        msg.reply "认证成功,您的账户下共有#{data.length}个订阅"
        #msg.send stderr if stderr
        console.log stderr if stderr

  checkAzure = "which azure"
  exec checkAzure, (error, stdout, stderr) ->
    if stdout == "" or stdout is "azure not found"
      console.log "WARN: you don't have azure in your $PATH"

  
  robot.respond /环境 开机 (.*)/i, (msg) ->
    sender   = msg.message.user.name.toLowerCase()
    machinename = msg.match[1]
    if sender!="leixu"
        msg.reply "对不起，你没有权限操作环境！，请联系管理员"
        return
    else
        if machinename in machines
            msg.reply "#{machinename}环境启动中，启动成功后会及时提醒您。"
        else
            msg.reply "不存在对应的环境:#{machinename}"
            return

    command = "az vm start --resource-group #{resourcegroup} --name #{machinename}"
    @maxBuffer = 1024*1024
    options =
     'maxBuffer': @maxBuffer
    exec command, options, (error, stdout, stderr) ->
        #msg.send error if error
        console.log error if error
        data = JSON.parse stdout
        startTime=data.startTime
        msg.reply "环境#{machinename}已成功开机，开机时间#{startTime}！"
        #msg.send stderr if stderr
        console.log stderr if stderr

  robot.respond /环境 关机 (.*)/i, (msg) ->
    sender   = msg.message.user.name.toLowerCase()
    machinename = msg.match[1]
    if sender!="leixu"
        msg.reply "对不起，你没有权限操作环境！，请联系管理员"
        return
    else
        if machinename in machines
            msg.reply "#{machinename}环境关闭中，启动成功后会及时提醒您。"
        else
            msg.reply "不存在对应的环境:#{machinename}"
            return

    command = "az vm stop --resource-group #{resourcegroup} --name #{machinename}"
    @maxBuffer = 1024*1024
    options =
     'maxBuffer': @maxBuffer
    exec command, options, (error, stdout, stderr) ->
        #msg.send error if error
        console.log error if error
        data = JSON.parse stdout
        endTime=data.endTime
        msg.reply "环境#{machinename}已成功关机，关机时间#{endTime}！"
        #msg.send stderr if stderr
        console.log stderr if stderr
