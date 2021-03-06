{assign} = require 'lodash'
_handle_error = require "#{__dirname}/helpers/_handle_error"
_build_query = require "#{__dirname}/helpers/_build_query"
act = require "#{__dirname}/../seneca/act"

module.exports = (args, done)->
  {model, query} = args
  if !model or !query
    errOpts =
      role: 'util'
      cmd: 'handle_err'
      type: 'missing_args'
      given:
        model: model
        query: query
      name: 'read'
      service: 'db'
    act errOpts
    .then (builtErr)->
      done null, err: builtErr
  else
    # Save the raw query for later logging
    raw_query = if query != 'all' then assign {}, query else 'all'

    # Build and run the query
    _build_query query, model
      .run()
      .then (doc)->
        if Array.isArray(doc) and doc.length is 0
          err =
            status: 404
            message: 'No documents returned'
          _handle_error 'read', err, done,
            model: model
            query: raw_query
        else
          done null, data: doc
      .catch (err)->
        _handle_error 'read', err, done,
          model: model
          query: raw_query
