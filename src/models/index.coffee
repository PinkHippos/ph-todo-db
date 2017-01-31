db = require "#{__dirname}/../db_instance"

# Require all models here
Todo = require "#{__dirname}/todo"

# Do any join registering here

# Export each model
module.exports =
  Todo: Todo
