#!usr/bin/perl
use 5.010;

# List of files 
$genePresence = 'Flagellin_distribution.txt';
$nodA_file = 'HMMscanTop/Flagellin_N.csv';
$nodA_out_file = 'HMMscanTopLists/Flagellin.txt';

# Find strains with all flagellin proteins
open($presence, '<', $genePresence);
while(<$presence>) {
	$_ =~ s/___/__/;
	@line = split("\t", $_);
	if(@line[1] == 1) {
		push(@species, @line[0]);
	}
}
close($presence);

# Get NodA proteins
open($nodA,'<',$nodA_file);
open($nodA_out,'>',$nodA_out_file);
while(<$nodA>) {
	@line = split(',',$_);
	if(@line[9] eq 'Flagellin_N') {
		@line2 = split('__', @line[0]);
		foreach $i (@species) {
			if(@line2[0] eq $i) {
				say $nodA_out (@line[0]);
			}
		}
	}
	elsif(@line[9] eq 'Flagellin_C') {
		@line2 = split('__', @line[0]);
		foreach $i (@species) {
			if(@line2[0] eq $i) {
				say $nodA_out (@line[0]);
			}
		}
	}
        if(@line[9] eq 'PRK12687') {
                @line2 = split('__', @line[0]);
                foreach $i (@species) {
                        if(@line2[0] eq $i) {
                                say $nodA_out (@line[0]);
                        }
                }
        }
}
close($nodA);
close($nodA_out);
system("grep -f 'HMMscanTopLists/Flagellin.txt' combined_proteomes_HMM_modified.faa > FlagellinProteins/Flagellin_all.faa");

$temp_file = 'temp.faa';
$final_out = 'FlagellinProteins/Flagellin_all.faa';
open($in, '<', $final_out);
open($out, '>', $temp_file);
while(<$in>) {
	$_ =~ s/\t/\n/;
	print $out ($_);
}
close($in);
close($out);
system("mv temp.faa FlagellinProteins/Flagellin_all.faa");
