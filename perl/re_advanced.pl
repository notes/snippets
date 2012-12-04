# positive look-ahead assertion
my $mailaddr1 = 'bob@example.jp';
$mailaddr1 =~ s/bob(?=\@example\.jp)/bill/;
print "$mailaddr1\n";

# negative look-ahead assertion
my $mailaddr2 = 'alice@example.net';
$mailaddr2 =~ s/alice(?!\@example\.jp)/sue/;
print "$mailaddr2\n";

# positive look-behind assertion
my $mailaddr3 = 'michael@example.org';
$mailaddr3 =~ s/michael@\Kexample\.org/example.com/;
print "$mailaddr3\n";

# negative look-behind assertion
my $mailaddr4 = 'peter@example.info';
$mailaddr4 =~ s/(?<!dave@)example\.info/example.jp/;
print "$mailaddr4\n";

# capture quoted-string with escape
my $quoted_string = '"foo \"bar\" baz"';

# using possessive quantifier
# to prevent backtracking
$quoted_string =~ /"(?:[^"\\]++|\\.)*+"/;
print "$&\n";

# using independent grouping
# the same meaning, but hard to read
$quoted_string =~ /"(?>(?:(?>[^"\\]+)|\\.)*)"/;
print "$&\n"

