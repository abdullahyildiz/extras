#!/usr/bin/perl

use strict;
use warnings;

@ARGV == 2 or die "Usage: $0 infile outfile\n";

open my $fhIN,  '<', $ARGV[0] or die $!;
open my $fhOUT, '>', $ARGV[1] or die $!;

while (<$fhIN>) {
    if (/\S/) {
        print $fhOUT $_;
    }
    else {
        print "Blank at line $.\n";
    }
}
