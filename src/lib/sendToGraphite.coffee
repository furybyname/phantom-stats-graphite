graphite = require('graphite')
_ = require('lodash')
fs = require('fs')

getMetrics = (page, graphiteConfig, callback) ->
  prefix = graphiteConfig['prefix']

  fs.readFile(process.cwd() + "/data/#{page}.json", (err, raw) ->
      count++

      parsed = JSON.parse(raw)

      for k, v of parsed
        name = "#{prefix}.#{page}.#{k}"
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
process = (urlConfig, graphiteConfig, callback) ->


  count = 0
  total = _.keys(urlConfig).length
  for page, url of urlConfig
    getMetrics(page, graphiteConfig, callback)



exports.run = process