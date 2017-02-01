_build_query = require "#{__dirname}/helpers/_build_query"
_handle_error = require "#{__dirname}/helpers/_handle_error"
act = require "#{__dirname}/../seneca/act"

module.exports = (args, done) ->
  {model, query} = args
  if !model or !query
    errOpts =
      role: 'util'
      cmd: 'handle_err'
      type: 'missing_args'
      given:
        model: model
        query: query
      name: 'destroy'
      service: 'db'
    act errOpts
    .then (builtErr)->
      done null, err: builtErr
  else
    _build_query query, model
      .delete()
      .execute()
      .then (res) ->
        done null, data: res
      .catch (err)->
        _handle_error 'destroy', err, done,
          model: model
          query: query
