
for my $arg (@ARGV) {
    next if $arg !~ /^--/;
    my ($opt, $value) = split(/=/, $arg, 2);
    if (defined $value) {
        # 引数付きオプション
        if ($opt eq "--hello") {
            print "Hello, ${value}!\n";
        } elsif ($opt eq "--bye") {
            print "Bye, ${value}!\n";
        } else {
            usage();
        }
    } else {
        # 引数無しオプション
        if ($opt eq "--foo-flag") {
            print "foo\n";
        } elsif ($opt eq "--bar-flag") {
            print "bar\n";
        } else {
            usage();
        }
    }
}
