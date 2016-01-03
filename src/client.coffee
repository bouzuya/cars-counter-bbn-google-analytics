# Google Analytics Core Reporting API
# https://developers.google.com/analytics/devguides/reporting/core/v3/reference?hl=ja
{ Promise } = require 'es6-promise'
fs = require 'fs'
google = require 'googleapis'

class Client
  @fromJSON: (file) ->
    json = JSON.parse fs.readFileSync file, encoding: 'utf-8'
    new Client json.client_email, json.private_key

  constructor: (clientEmail, privateKey) ->
    @_json =
      type: 'service_account'
      client_email: clientEmail
      private_key: privateKey
    @_authorizedClient = null
    @_scopes = [
      'https://www.googleapis.com/auth/analytics'
      'https://www.googleapis.com/auth/analytics.readonly'
    ]

  get: ({ viewId, from, to, metrics }) ->
    @_authorize()
    .then (auth) =>
      params =
        'auth': auth
        'ids': 'ga:' + viewId
        'start-date': from
        'end-date': to
        'metrics': metrics.join(',')
      @_promisedAnalyticsDataGet params
    .then (data) ->
      obj = data.totalsForAllResults
      ([k, v] for k, v of obj).reduce (o, [k, v]) ->
        o[k.replace(/^ga:/, '')] = parseInt(v, 10)
        o
      , {}

  _authorize: ->
    return Promise.resolve(@_authorizedClient) if @_authorizedClient?
    json = @_json
    scopes = @_scopes
    @_promisedFromJSON json
    .then (client) ->
      client.createScoped scopes
    .then (scopedClient) =>
      @_promisedAuthorize scopedClient

  _promisedAuthorize: (scopedClient) ->
    new Promise (resolve, reject) ->
      scopedClient.authorize (err) ->
        return reject(err) if err?
        resolve scopedClient

  _promisedFromJSON: (json) ->
    new Promise (resolve, reject) ->
      google.auth.fromJSON json, (err, client) ->
        return reject(err) if err?
        resolve client

  _promisedAnalyticsDataGet: (params) ->
    new Promise (resolve, reject) ->
      google.analytics('v3').data.ga.get params, (err, result) ->
        return reject(err) if err?
        resolve result

module.exports = Client
