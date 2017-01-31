moment = require 'moment'

models = require "#{__dirname}/../models"
_handle_error = require "#{__dirname}/helpers/_handle_error"

module.exports = (args, done) ->
  {model, insert, saveAll} = args
  if !model or !insert
    errOpts =
      role: 'util'
      cmd: 'handle_err'
      type: 'missing_args'
      given: [
        {name: 'model', value: model},
        {name: 'insert', value: JSON.stringify insert}
      ]
      name: 'create'
      service: 'db'
    act errOpts
    .then (builtErr)->
      done null, err: builtErr
  else
    insert.createdAt = moment().format()
    Model = models[model]
    insertMethod = {}
    base = new Model insert
    if saveAll
      base = base.saveAll saveAll
    else
      base = base.save()
    base
      .then (res)->
        done null, data: res
      .catch (err)->
        _handle_error 'create', err, done,
          model: model
          insert: insert
