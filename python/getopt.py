import optparse

p = optparse.OptionParser()
p.set_usage("SampleUsage [options] foo bar")
p.add_option("-n", "--new", action="store_true", help="create new option")
p.add_option("-r", "--reload", action="store_true", help="reload automatically")
p.add_option("-t", "--time", action="store", type="int", dest="interval", help="time interval")
p.add_option("-m", "--multi", action="append", type="string", help="set this option many times")
p.add_option("-M", "--many", action="store", type="string", nargs=3, help="exact three arguments required")

opts, args = p.parse_args()
if opts.new:
    print "New option set"
if opts.reload:
    print "Reload options set"
if opts.interval is not None:
    print "Time interval: {0} secs".format(opts.interval)
if opts.multi:
    print opts.multi
if opts.many:
    print opts.many

