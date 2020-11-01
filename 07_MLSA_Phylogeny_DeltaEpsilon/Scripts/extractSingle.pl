#!usr/bin/perl
use File::Find;
use 5.010;
use Cwd;

# set variables
$species_list = 'Input_files/genomeList.txt';
$pwd = cwd();
$total = 0;
$count = 0;

# make an array of the species names
open($species,'<',$species_list);
while(<$species>) {
	@line = split("\t",$_); # split the input line into an array based on commas
	push(@genomes,@line[0]); # make an array of the species names
}
close($species);

# script for iteratively working through each output file from coutProteins
$parent = "$pwd/MarkerScannerOutput"; # directory with the coutProteins output
find( \&search_all_folder, $parent ); # prepare a list of the files
sub search_all_folder { # prepare a list of the files
	chomp $_;
	return if $_ eq '.' or $_ eq '..';
	&read_files ($_) if (-f);
}

# Collect single copy proteins
sub read_files {
	($filename) = @_;
	foreach $genome (@genomes) {
		$genome2 = $genome . '__';
		$count = 0;
		open $fh, '<', $filename;
		while(<$fh>) { # this loop will add 1 to the count variable when it encounters the genome name.  Does it for each species
			if(/$genome2/) {
				$count++;
			}
		}
		close($fh);
		if($count == 1) {
			$outputFile = "$pwd/MarkerScannerSingle/$filename";
			open $out, '>>', $outputFile;
			open $fh, '<', $filename;
			while(<$fh>) {
				if(/>/) {
					$test = 0;
				}
				if(/$genome2/) {
					$test = 1;
				}
				if($test == 1) {
					print $out ($_);
				}
			}
			close($fh);
			close($out);
		}
	}
}
