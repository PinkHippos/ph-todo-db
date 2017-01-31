act = require "#{__dirname}/../../seneca/act"

_build_message = (type, args)->
  base = "Error during #{type} on db\n
  --- Arguments ---\n"
  for arg, val of args
    val = JSON.stringify val
    base = "#{base}-- #{arg}: #{val}\n"
  base

##### _handle_error #####
# Handles an error from the db and calls done with err: formatted_err
# @params: type -> string
# @params: err -> object
# @params: done -> function
# @params: args -> object
module.exports = (type, err, done, args)->
  status = err.status
  message = _build_message type, args

  switch err.name
    when 'ValidationError' then status = 400
    when 'DuplicatePrimaryKeyError'
      status = 400
      message = 'The primary_key has already been used'
      err = status: status, message: message
    when 'DocumentNotFoundError'
      message = 'No documents returned'
      status = 404
      err = status: status, message: message
    else
      if err.status != 404
        console.log 'UNHANDLED DB ERROR', err.name, err
  logOpts =
    role: 'util'
    cmd: 'handle_err'
    type: 'general'
    message: message
    service: 'db'
    err: err
  act logOpts
  done null, err: {
    message: message
    status: status
    err: err
  }
