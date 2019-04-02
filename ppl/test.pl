#!/usr/bin/perl

use strict;
use warnings;

open my $in, '<', "myfile" or die "Can't read old file: $!";

my $content = do { local $/; <$in> }; # slurp!

$content =~ s/[^\n]+PERL+?//s;

print $content;

close $in;

