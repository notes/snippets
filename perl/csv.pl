use Text::CSV;

my $c = new Text::CSV;

# normal
$c->parse("a,b,c,d,e");
my @f1 = $c->fields();
print "[$f1[0]] [$f1[2]] [$f1[4]]\n";

# with quote and escape
$c->parse('"a",b,"c,c",d,"e""e"');
my @f2 = $c->fields();
print "[$f2[0]] [$f2[2]] [$f2[4]]\n";
