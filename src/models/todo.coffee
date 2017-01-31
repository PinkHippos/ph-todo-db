db = require "#{__dirname}/../db_instance"
{type} = db
Todo = db.createModel 'Todo',
  text: type.string().required()
  status: type.string().default('new').enum ['new', 'inProgress', 'complete']
  author: type.string()
module.exports = Todo
