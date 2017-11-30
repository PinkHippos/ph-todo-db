seneca = require "#{__dirname}/instance"
client = seneca.client {
  type: 'amqp'
  pin: 'role:*,cmd:*'
}
module.exports = (actionOpts)->
  new Promise (resolve, reject)->
    client.act actionOpts, (err, res)->
      if err or res.err
        reject {
          seneca_err: err
          action_err: res.err
        }
      else
        resolve res.data
