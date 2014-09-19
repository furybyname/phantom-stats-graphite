stats = require('phantom-stats')
fs = require('fs')
_ = require('lodash')

getValue = (path, data) ->
  parts = path.split('.')
  current = 0
  d = data
  while true
    d = d[parts[current]]
    current += 1
    if parts.length == current
      return d

  return -1

processData = (data, pageName, config, callback) ->
  result = {}
  for stat, path of config
    value = getValue(path, data)
    result[stat] = value

  file = "./data/#{pageName}.json"
  fs.unlink(file, (err) -> fs.writeFile(file, JSON.stringify(result), (err) -> callback(err is null)))


isDone = (count, total) -> count >= total

doRun = (page, url, statsConfig, callback) ->
  stats.run(url, (data) ->
      processData(data, page, statsConfig, (success) ->
        if success == false then console.log pageName
        process.exit(1) unless success

        if isDone(current++, total) then callback(true)
      )
    )

current = 0
total = 0
run = (urlConfig, statsConfig, callback) ->
  total = _.keys(urlConfig).length

  for pageName, url of urlConfig
    doRun(pageName, url, statsConfig, callback)

exports.run = run
