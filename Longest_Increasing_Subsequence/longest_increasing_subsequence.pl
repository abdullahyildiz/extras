#!/usr/bin/perl

# author: abdullahyildiz

use warnings; #pragma to control optional warnings
use strict;

print "\n";
print "----------------------------------------------------\n";

my $fileName = 'sequence_set.txt';
open my $FILE, $fileName or die "Could not open $fileName: $!";

my @array = (0);

while( my $line = <$FILE> )  {   
    chomp $line;
	@array = split(" ", $line);
	
	print "ARRAY INSTANCE: ";
	foreach(@array){
		print $_, " ";
	}
	
	my $arraySize = @array;
	print "\nARRAY SIZE: $arraySize\n";


my $i = 0;
my $head = $array[0];

#####################################################################################

my @solutionSet1 = (0);
my @solutionSet2 = (0);

my $head1 = $array[0];
my $head2 = $array[0];

my $index1 = 0; # length of solutionSet1
my $index2 = 0; # length of solutionSet2

for($i = 1; $i < $arraySize; $i++){
	if($index1 == 0){
		if($head1 < $array[$i]){
			$solutionSet1[$index1] = $head1;
			$index1++;
			$solutionSet1[$index1] = $array[$i];
			$index1++;
			$head1 = $array[$i];
		}
		else{
			$solutionSet1[$index1] = $array[$i];
			$index1++;
			$solutionSet2[$index2] = $head1;
			$index2++;
			$head2 = $head1;
			$head1 = $array[$i];
		}
	}
	elsif($head1 < $array[$i]){
		$solutionSet1[$index1] = $array[$i];
		$index1++;
		$head1 = $array[$i];
	}
	else{
		if($solutionSet1[$index1-2] < $array[$i] && $solutionSet1[$index1-1] > $array[$i]){
			$solutionSet1[$index1-1] = $array[$i];
			$head1 = $array[$i];
		}
		elsif($index2 == 0){
			$solutionSet2[$index2] = $array[$i];
			$index2++;
			$head2 = $array[$i];
		}
		elsif($solutionSet2[$index2-1] > $array[$i]){
			$solutionSet2[$index2-1] = $array[$i];
			$head2 = $array[$i];
		}
		elsif($solutionSet2[$index2-1] < $array[$i]){
			$solutionSet2[$index2] = $array[$i];
			$index2++;
			$head2 = $array[$i];
			if($index2 > $index1){
				@solutionSet1 = @solutionSet2;
				@solutionSet2 = (0);
				$index1 = $index2;
				$index2 = 0;
				$head1 = $array[$i];
				$head2 = 0;
			}
		}
	}
}

print "LONGEST INCREASING SUBSEQUENCE: ", @solutionSet1, "\n";
print "----------------------------------------------------\n";

}

close $FILE;