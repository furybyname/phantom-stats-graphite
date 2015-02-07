graphite = require('graphite')
_ = require('lodash')
fs = require('fs')

getMetrics = (page, device, graphiteConfig, callback) ->
  prefix = graphiteConfig['prefix']

  filename = "#{page}.#{device}"
  p = process.cwd() + "/data/#{filename}.json"
  fs.readFile(p, (err, raw) ->
      count++

      parsed = JSON.parse(raw)

      for k, v of parsed
        name = "#{prefix}.#{device}.#{page}.#{k}"
        metrics[name] = v

      if count == total

        client = graphite.createClient(graphiteConfig['url'])

        client.write(metrics, new Date().valueOf(), (err)->
          callback(true)
        )
    )

count = 0
total = 0
metrics = {}
processRun = (urlConfig, graphiteConfig, devices, callback) ->


  count = 0
  total = _.keys(urlConfig).length * devices.length
  for page, url of urlConfig
    for device in devices
      getMetrics(page, device, graphiteConfig, callback)



exports.run = processRun