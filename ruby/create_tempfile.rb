require "tempfile"

# create a linked file
tf = Tempfile.new("prefix")

# create a linked file with suffix
tf = Tempfile.new(["prefix", ".dat"])

# create a linked file in the specific directory
tf = Tempfile.new("prefix", "/path/to/dir")

# unlinked file is not supported explicitly
tf = Tempfile.new("prefix")
tf.unlink

