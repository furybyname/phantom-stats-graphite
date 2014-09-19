phantom-stats-graphite
=============

HARvest data from multiple urls and send to graphite!

## Installation

`npm install phantom-stats-graphite`

or `npm install -g phantom-stats-graphite`

### Usage

#### Harvest

`node_modules/.bin/run-phantom-stats path/to/config.json `

or `run-phantom-stats path/to/config.json `

#### Send to graphite

`node_modules/.bin/send-to-graphite config.json `

or `send-to-graphite config.json `

# From source

## Installation

`git clone git@github.com:furybyname/phantom-stats-graphite.git`

`cd phantom-stats-graphite`

`npm install`

`grunt coffee`

### Usage

`node bin/phantom-stats-graphite config.json `

Be sure to modify the config (see source for example) to point at your site and a valid graphite instance
 
