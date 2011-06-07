use Text::CSV;

my $c = new Text::CSV;

# 普通
$c->parse("a,b,c,d,e");
my @f = $c->fields();
print "[$f[0]] [$f[2]] [$f[4]]\n";

# quoteしてあってもOK
$c->parse('"a",b,"c,c",d,"e""e"');
my @f = $c->fields();
print "[$f[0]] [$f[2]] [$f[4]]\n";
