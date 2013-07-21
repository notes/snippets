use strict;
use warnings;
use Carp;

my ($result, $status, $coredump) = call_system(@ARGV);

if ($result eq q(exit) && $status == 0) {
  print "success\n";
} else {
  if ($result eq q(exit)) {
    print "exit with status ${status}\n";
  } elsif ($result eq q(error)) {
    print "failure with errno: ${status}\n";
  } elsif ($result eq q(signal)) {
    print "killed by signal ${status}\n";
    if ($coredump) {
      print "core dumped\n";
    }
  } else {
    croak "call_system() returned unexpected result";
  }
}

sub call_system {
  my $system_ret;
  {
    local $SIG{__WARN__} = sub {};
    $system_ret = system(@_);
  }

  if ($system_ret == -1) {
    # system call fork() or wait() failed
    my $errno = $!;
    return (q(error), $errno);
  }

  my $signal = $system_ret & 0x7F;
  if ($signal == 0) {
    # end by exit() call
    my $exit_status = ($system_ret >> 8) & 0xFF;
    return (q(exit), $exit_status);
  } else {
    # killed by signal
    my $coredump = $system_ret & 0x80;
    return (q(signal), $signal, $coredump);
  }
}

