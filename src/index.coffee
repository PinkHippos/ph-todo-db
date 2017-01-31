seneca = require "#{__dirname}/seneca/instance"
act = require "#{__dirname}/seneca/act"
version = process.env.PH_DB_V or 'X.X.X'
listener = seneca
  .use './plugin'
  .ready (err)->
    if err
      args =
        role: 'util'
        cmd: 'handle_err'
        service: 'db'
        message: 'Error with starting seneca listener in db'
        err: err
    else
      base =
        type: 'amqp'
        pin: 'role:db,cmd:*'
      listener.listen base
      args =
        role: 'util'
        cmd: 'log'
        service: 'db'
        type: 'general'
        message: "v#{version} DB started"
      act args
