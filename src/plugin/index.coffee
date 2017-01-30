q = require 'q'
moment = require 'moment'
models = require "#{__dirname}/models"
{r} = require "#{__dirname}/db_config"
act = require "#{__dirname}/seneca_config/act"
module.exports = (options)->
  patterns =
    create:
      cmd: 'create'
      # model: string
      # insert: object
    read:
      cmd: 'read'
      # model: string
      # query:
      #   to_parse:
      #     joins & some filters
      #   primary_key: string
      #   filters: object
      #   without: array
      #   pluck: array
    update:
      cmd: 'update'
      # model: string
      # query:
      #   primary_key: string
      #   filters: object
      # changes: object
    destroy:
      cmd: 'destroy'
      # model: string
      # query:
      #   primary_key: string
      #   filters: object
    watch:
      cmd: 'watch_feed'
      # model: string
      # cb: function

  for pattern, val of patterns
    val.role = 'db'
    fn = require "#{__dirname}/#{pattern}"
    console.log 'PATTERN', val
    console.log 'FN', fn

    @add val, require "#{__dirname}/#{pattern}"
