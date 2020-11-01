#!/usr/bin/perl
use 5.010;

# Sinorhizobium genomes
$genomes = 'Input_files/genomeList.txt'; # file to get the information of the files

open($gen,'<',$genomes);
while(<$gen>) {
	chomp;
	@line = split("\t",$_); # split the input line into an array based on commas
	push(@species,@line[0]); # make an array of the species names
	push(@unique,@line[1]); # make an array of if it is the representative genome or not
}
close($gen);

foreach $species (@species) {
		$protein = $species;
		$species .= '.faa';
		$species2 = 'Genome_files/';
		$species2 .= $species;
		$output = 'Proteomes/';
		$output .= $species;
		open($in, '<', $species2);
		open($out, '>', $output);
		while(<$in>) {
			if(/>/) {
				$total++;
				$total2 = "__$total";
				print $out (">$protein$total2\n");
			}
			else {
				print $out ($_);
			}
		}
		close($in);
		close($out);
		print("$species\n");
}
