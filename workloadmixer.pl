#!/usr/local/bin/perl
use warnings;
use Cwd;
use File::Spec;
use Algorithm::Combinatorics qw(combinations);



#PRINT WELCOME MESSAGE
print "\nMacSim Workload List Generator v1\n\n";

#PRINT DATE & TIME
@months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
@weekDays = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
$year = 1900 + $yearOffset;
$theTime = "$hour:$minute:$second, $weekDays[$dayOfWeek] $months[$month] $dayOfMonth, $year";
print $theTime; 
print "\n\n";

$workload = "workload.lst";

open(WORKLOAD, ">", $workload) or die "can't open the file!";

my $abs_dir = "../CSE620-2/macsim.UCP";
my $rel_dir = File::Spec->abs2rel($abs_dir, cwd);

print WORKLOAD "TEST ", $abs_dir, " ", $rel_dir; 

close(WORKLOAD);


my $dir = '../CSE620-2/macsim.UCP/trace/x86/spec2006/trace_simpoint';
my @workloads;

opendir(DIR, $dir) or die $!;

while (my $file = readdir(DIR)) {

    # Use a regular expression to ignore files beginning with a period
    next if ($file =~ m/^\./);
    
    print "$file\n";
    push(@workloads, $file);

}

closedir(DIR);

my $iter = combinations(\@workloads, 15);
my $number=0;
#scalar context gives an iterator
    while (my $p = $iter->next) {
	print "@$p\n";
}
