import re

# match at the start
string = "foo=1 bar=2 baz=3"
m = re.search(r"foo=(\S+)", string)
print m.group(1)

# match through the string
string = "foo=1 bar=2 baz=3"
m = re.search(r"bar=(\S+)", string)
print m.group(1)

# case insensitive
string = "foo=1 BAR=2 baz=3"
m = re.search(r"bar=(\S+)", string, re.I)
print m.group(1)

# escape meta-characters
string = "foo=1 bar=*+[] baz=3"
m = re.search(re.escape(r"bar=*+[]"), string)
print m.group(0)

# replace all occurences
string = "foo bar baz foo"
replaced = re.sub(r"foo", r"hoge", string)
print replaced

# replace only the first one
string = "foo bar baz foo"
replaced = re.sub(r"foo", r"hoge", string, 1)
print replaced

# split by regexp
string = "foo bar\tbaz\rhoge"
split_words = re.split(r"\s+", string)
print split_words

# split by regexp with upper limit
string = "foo bar\tbaz\rhoge"
split_words = re.split(r"\s+", string, 2)
print split_words
