#!/usr/bin/perl
use strict;
use warnings;
use Compress::Zlib;

undef $/;
print uncompress(<>);
