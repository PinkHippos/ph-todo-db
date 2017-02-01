act = require "#{__dirname}/../seneca/act"
##### watchModelFeed #####
# Watches a model table for changes and handles with cb if provided
# @params: model -> string ('Todo', 'User')
# @params: cb -> function (called with changes)
module.exports = (args, done)->
  {model, cb} = args
  models[model]
    .changes()
    .then (feed)->
      if !cb
        feed.each (e, doc)->
          if e
            _handle_error "#{model} feed watch", e, done,
              model: model
              cb: cb
          else
            message = "Changes to #{model}\n
            #{JSON.stringify doc}"
            logOpts =
              role: 'util'
              cmd: 'log'
              type: 'general'
              message: message
            act logOpts
      else
        cb feed
  done null, message: "Change feed for #{model} started"
