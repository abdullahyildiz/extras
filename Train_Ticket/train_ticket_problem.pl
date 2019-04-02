#!/usr/bin/perl

# author: abdullahyildiz

use warnings; #pragma to control optional warnings
use strict;

print "\n";
print "----------------------------------------------------\n";

my $fileName = 'ticket_costs.txt';
open my $FILE, $fileName or die "Could not open $fileName: $!";

my @array = (0);
my @solutionMatrix = (0);

my @costTable = ([],[]);
my $i = 0;
my $j = 0;
my $arraySize;

while( my $line = <$FILE> )  {   
 
    chomp $line;
	@array = split(" ", $line);
	
	$arraySize = @array;
	print "\nARRAY SIZE: $arraySize\n";

	for($j = 0; $j < $arraySize; $j++){
		$costTable[$i][$j] = $array[$j];
	}
	
	$i++;
	
}

close $FILE;

for($i = 0; $i < $arraySize; $i++){
	
	for($j = 0; $j < $arraySize; $j++){
		print $costTable[$i][$j], " ";
	}
	print "\n";
}

my $totalCost = 0;
my @cities = 0;
$j = 0;
$i = 0;

print "\n";

$totalCost = $costTable[0][$j+1];

while($j < $arraySize - 2){ 
	if(($totalCost + $costTable[$j+1][$j+2]) > $costTable[0][$j+2]){ 
		$totalCost = $costTable[0][$j+2];
		@cities = 0;
		push(@cities, $j+2);
	}
	else{
		$totalCost = $totalCost + $costTable[$j+1][$j+2];
		my $citySize = @cities;
		if($citySize > 1){
			pop(@cities);
		}
		push(@cities, $j+1, $j+2);
	}
	$j++;
}

print "TOTAL COST of TRAVEL: ", $totalCost, "\n";
print "by VISITING FOLLOWING CITIES: ";

foreach(@cities){
	print $_, " ";
}