#!usr/bin/perl
use 5.010;

$output = 'Input_files/genomeList.txt';

open($out, '>', $output);
while(<>) {
	unless(/#/ or /GenBank/) {
		chomp;
		$_ =~ s/\"//g;
		@line = split(',', $_);
		unless(@line[15] eq "") {
			@line[2] =~ s/\ /_/g;
			@line[2] =~ s/__/_/g;
			@line[2] =~ s/__/_/g;
			@line[2] =~ s/__/_/g;
			@line[2] =~ s/__/_/g;
			@line[2] =~ s/__/_/g;
			if(@line[2] eq "") {
				$total++;
				@line[2] = "NoStrain$total";
			}
			if(/Candidatus/) {
				@species = split(' ', @line[0]);
				say $out ("@species[0]_@species[1]_@species[2]_@line[2]\t@line[15]");
			}
			else {
				@species = split(' ', @line[0]);
				say $out ("@species[0]_@species[1]_@line[2]\t@line[15]");
			}
		}
	}
}
close($out);
