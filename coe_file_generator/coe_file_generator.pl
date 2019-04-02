#!/usr/bin/perl

use warnings; #pragma to control optional warnings
use strict;

my $fileName = $ARGV[0];

if($#ARGV == -1 || $#ARGV > 0){
    die("Run the script as perl dump_memory.pl <MEMORY_INIT_FILE.txt>");
}

my @memArray = 0 x 1024;

for(my $i = 0; $i < 1024; $i++){
    $memArray[$i] = 0;
}

open my $FILEHANDLE1, $fileName or die "cannot open $fileName: $!";

while (my $line = <$FILEHANDLE1>) {

    my $addr;
    my $val;

    chomp $line;

    my @wordsInLine = split(" ", $line);

    if($wordsInLine[0] =~ /(.*)[:]/){
	$addr = $1;
	print "$addr ";
    }
    if($wordsInLine[1] =~ /[0][x](.*)/){
	$val = $1;
	print "$val\n";
    }

    $memArray[$addr] = $val;
}

close($FILEHANDLE1);

open (my $FILEHANDLE2, ">dump_memory.coe");

print $FILEHANDLE2 "memory_initialization_radix=16;\n";
print $FILEHANDLE2 "memory_initialization_vector=\n";

for(my $i = 0; $i < 1024; $i++){
    print $FILEHANDLE2 $memArray[$i];
    if($i == 1023){
	print $FILEHANDLE2 ";";
    }
    else{
	print $FILEHANDLE2 ",\n";
    }
}

close($FILEHANDLE2);
