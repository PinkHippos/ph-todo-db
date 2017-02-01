_build_query = require "#{__dirname}/helpers/_build_query"
_handle_error = require "#{__dirname}/helpers/_handle_error"
act = require "#{__dirname}/../seneca/act"
module.exports = (args, done) ->
  {model, query, changes} = args
  if !model or !query or !changes
    errOpts =
      role: 'util'
      cmd: 'handle_err'
      type: 'missing_args'
      given: [
        {name: 'model', value: model},
        {name: 'query', value: query},
        {name: 'changes', value: changes}
      ]
      name: 'update'
      service: 'db'
    act errOpts
    .then (builtErr)->
      done null, err: builtErr
  else
    _build_query query, model
      .update changes
      .run()
      .then (res) ->
        done null, data: res
      .catch (err)->
        _handle_error 'update', err, done,
          model: model
          query: query
          changes: changes
