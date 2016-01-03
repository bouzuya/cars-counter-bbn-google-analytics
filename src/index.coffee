Client = require './client'
moment = require 'moment'

# process.env
#   GOOGLE_ANALYTICS_VIEW_ID: '99999999'
#   GOOGLE_ANALYTICS_CLIENT_EMAIL: 'xyz-999@xyz999.iam.gserviceaccount.com'
#   GOOGLE_ANALYTICS_PRIVATE_KEY: '"-----BEGIN PRIVATE KEY-----\n..."'
# result =
#   'blog-weekly-users': 123
#   'blog-weekly-sessions': 456
#   'blog-weekly-pageviews': 789
#   'blog-monthly-users': 1230
#   'blog-monthly-sessions': 4560
#   'blog-monthly-pageviews': 7890
module.exports = (callback) ->
  today = moment().format('YYYY-MM-DD')
  week = moment(today).subtract(1, 'week').format('YYYY-MM-DD')
  month = moment(today).subtract(1, 'month').format('YYYY-MM-DD')
  viewId = process.env.GOOGLE_ANALYTICS_VIEW_ID
  clientEmail = process.env.GOOGLE_ANALYTICS_CLIENT_EMAIL
  privateKey = JSON.parse process.env.GOOGLE_ANALYTICS_PRIVATE_KEY
  metrics = [
    'ga:pageviews'
    'ga:sessions'
    'ga:users'
  ]
  client = new Client clientEmail, privateKey
  [
    { name: 'weekly', from: week, to: today, metrics }
    { name: 'monthly', from: month, to: today, metrics }
  ].reduce (promise, { name, from, to, metrics }) ->
    promise
    .then (results) ->
      client.get { viewId, from, to, metrics }
      .then (obj) ->
        ([k, v] for k, v of obj).forEach ([k, v]) ->
          results['blog-' + name + '-' + k] = v
        results
  , Promise.resolve({})
  .then (counts) ->
    callback null, counts
  .catch (error) ->
    callback error
