thinky = require 'thinky'
config_opts =
  db: process.env.DB_NAME or 'test'
  port: process.env.PH_DB_PORT or 28015
  host: process.env.PH_DB_HOST or 'rethinkdb'
  authKey: process.env.PH_DB_AUTHKEY
db = thinky config_opts
module.exports =
  db: db
  r: db.r
