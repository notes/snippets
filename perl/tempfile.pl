use strict;
use warnings;
use File::Temp qw(tempfile);

# create an unlinked file in File::Spec->tmpdir
my $fh = tempfile();

# create a linked file in File::Spec->tmpdir
my ($fh, $filename) = tempfile();

# create a linked file in the specific directory
my ($fh, $filename) = tempfile(DIR => "/path/to/tmp");

# with filename of fixed pattern in current directory
my ($fh, $filename) = tempfile("myfileXXXXXX");

# with filename of fixed pattern in the specific directory
my ($fh, $filename) = tempfile("myfileXXXXXX", DIR => "/path/to/tmp");

# with filename of fixed pattern and suffix
my ($fh, $filename) = tempfile("myfileXXXXXX", SUFFIX => ".dat");

