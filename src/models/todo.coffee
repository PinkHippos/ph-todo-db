db = require "#{__dirname}/../db_instance"
{type, createModel} = db
Todo = createModel 'Todo',
  text: type.string()
    .required()
  status: type.string()
    .default('new')
    .enum ['new', 'inProgress', 'complete']
  userID: type.string()
