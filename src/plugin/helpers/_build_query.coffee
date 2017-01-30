{parse} = require 'json-fn'
{assign} = require 'lodash'

act = require "#{__dirname}/../../seneca/act"
models = require "#{__dirname}/../../models"
{r} = require "#{__dirname}/../../db_config"

##### _parse_query #####
# Converts string query into valid js
# @params: raw_query -> stringified js
# @returns: object
_parse_query = (raw_query)->
  parsed = parse raw_query.to_parse
  delete raw_query.to_parse
  # return the parsed keys with the initial query
  assign {}, parsed, raw_query

##### _format_filters #####
# Dynamically applys filters to a query base.
# @params: filters -> obj || [obj]
# @returns: query base with filters chained on
_format_filters = (filters, base)->
  filtered_base = assign {}, base
  if Array.isArray filters
    for filter in filters
      filtered_base = filtered_base.filter filter
  else
    filtered_base = filtered_base.filter filters
  filtered_base

##### _build_query #####
# Builds a query with the given object
# @params: query -> object
# @params: model_name -> string
# @returns: Thinky query chain
module.exports = (query, modelName)->
  model = models[modelName]
  if !model
    errOpts =
      role: 'util'
      cmd: 'handle_err'
      type: 'general'
      message: "No model found for: #{modelName}"
      service: 'db'
    act errOpts
  else
    base = model
    if query != 'all'
      if query.to_parse
        query = _parse_query query
      {primary_key, filters, joins, without, pluck, orderBy} = query
      if orderBy
        {order, index} = orderBy
        base = base.orderBy index: r[order](index)
      if primary_key
        base = base.get primary_key
      else if filters
        base = _format_filters filters, base
      if without
        base = base.without without
      if pluck
        base = base.pluck pluck
      if joins
        base = base.getJoin joins
    base
