# capture quoted-string with escape
my $quoted_string = '"foo \"bar\" baz"';
# using possessive quantifier
# prevent backtracking
$quoted_string =~ /"(?:[^"\\]++|\\.)*+"/;
print "$&\n";
# using independent grouping
# the same meaning, but hard to read
$quoted_string =~ /"(?>(?:(?>[^"\\]+)|\\.)*)"/;
print "$&\n"

