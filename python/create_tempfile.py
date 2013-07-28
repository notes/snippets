import tempfile

# create an unlinked file object
tf = tempfile.TemporaryFile()

# create a linked file object with fixed pattern filename
tf = tempfile.NamedTemporaryFile(dir="/path/to/tmp", prefix="myfile", suffix=".dat")

# create a linked file object but it's not deleted after closed
tf = tempfile.NamedTemporaryFile(dir="/path/to/tmp", delete=False)

