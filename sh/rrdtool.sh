# see http://oss.oetiker.ch/rrdtool/doc/index.en.html

# create RRD data file
#   --start: data source start time ("N" means now)
#   --step: data insertion interval
#   DS: data source definition
#     GAUGE: data type
#     120: heartbeat interval to define a PDP (Primary Data Point)
#     U: min/max values are undetermined
#   RRA: roundrobin archive definition
#     AVERAGE: consolidation function
#     0.5: if half of PDPs in the range are unknown, the consolidated value is also unknown
#     1: how many PDPs of the data source are consolidated into an archive value
#     1440: how many RRA values are preserved in the file, which determines the file size
rrdtool create x.rrd --start N --step 60 \
  DS:dataSourceName:GAUGE:120:U:U \
  RRA:AVERAGE:0.5:1:1440

rrdtool update x.rrd $(date +%s):100
rrdtool update x.rrd $(date -d '1 minute' +%s):110
rrdtool update x.rrd $(date -d '2 minutes' +%s):120

# draw graph
#   --start: graph start time
#   --end: graph end time
#   --step: graph min. time between points
#   DEF: data series definition (using data source)
#   AREA: how to draw the series graphically
rrdtool graph x.png --start N --end $(date -d '2 hours' +%s) --step 60 \
  DEF:myds=x.rrd:dataSourceName:AVERAGE \
  AREA:myds#fdfd46:seriesName

