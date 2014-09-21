stats = require('phantom-stats')
fs = require('fs')
_ = require('lodash')

getValue = (path, data) ->
  try
    parts = path.split('.')
    current = 0
    d = data
    while true
      d = d[parts[current]]
      current += 1
      if parts.length == current
        return d
  catch

  return -1

ensureDirectoryExists =(path, mask, cb) ->
    if typeof mask == 'function'
      cb = mask
      mask = 0o0777

    fs.mkdir(path, mask, (err) ->

      if (err)
        if (err.code == 'EEXIST') then cb(null) else cb(err)

      else
      cb(null)
    )

processData = (data, pageName, config, callback) ->
  result = {}
  for stat, path of config
    value = getValue(path, data)
    if value == -1
      continue

    result[stat] = value

  file = process.cwd() + "/data/#{pageName}.json"
  ensureDirectoryExists(process.cwd() + '/data', ->
    fs.unlink(file, (err) -> fs.writeFile(file, JSON.stringify(result), (err) -> callback(err is null, err)))
  )



isDone = (count, total) -> count >= total

doRun = (page, url, statsConfig, harSummaryConfig, callback) ->
  stats.run(url, harSummaryConfig, (data) ->
      processData(data, page, statsConfig, (success, err) ->
        if success == false then console.log page, err
        process.exit(1) unless success

        if isDone(current++, total) then callback(true)
      )
    )

current = 0
total = 0
run = (urlConfig, statsConfig, harSummaryConfig, callback) ->
  total = _.keys(urlConfig).length

  for pageName, url of urlConfig
    doRun(pageName, url, statsConfig, harSummaryConfig, callback)

exports.run = run
