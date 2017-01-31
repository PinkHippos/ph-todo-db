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

  for pattern_name, val of patterns
    val.role = 'db'
    fn = require "#{__dirname}/#{pattern_name}"
    console.log 'PATTERN', val
    console.log 'FN', fn
    # Add each of the patterns and respective callbacks
    # to register them with seneca for use elsewhere
    @add val, require "#{__dirname}/#{pattern_name}"
