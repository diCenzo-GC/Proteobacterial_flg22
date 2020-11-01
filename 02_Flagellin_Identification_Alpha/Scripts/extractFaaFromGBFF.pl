#!/usr/bin/perl
use 5.010;

# Files
$input = 'Input_files/genomeList.txt';
$output = 'combined_proteomes_HMM.faa';

# Extract species names
open($in,'<',$input);
while(<$in>) {
    chomp;
    @line = split("\t",$_);
    push(@species,@line[0]);
}
close($in);

# Get the proteins
open($out, '>', $output);
foreach $species (@species) {
    say("$species");
    $strain = $species;
    $species .= '.gbff';
    $species2 = 'Genome_files/';
    $species2 .= $species;
    open($in, '<', $species2);
    while(<$in>) {
        if(/LOCUS/) {
            @line = split('       ', $_);
            @line2 = split(' ', @line[1]);
            $replicon = @line2[0];
        }
        if(/\ \ \ \ \ gene\ \ \ \ \ \ \ \ \ \ \ \ /) { # Reset the pseudo and translation markers
            $pseudo = 0;
            $translation = 0;
	    $test = 1;
        }
        if(/\/pseudo/) { # Deterime if a pseudo gene, which therefore has no protein sequence
            $pseudo = 1;
        }
        if(/\/locus_tag/) { # Get the locus tag
            @line = split("\"", $_);
            $locus = @line[1];
        }
        if(/\ \/translation/) { # Extract protein if not a pseudo gene
            if($pseudo == 0 && $test == 1) {
                $total++;
                $total2 = "__$total";
                $locus2 = "__$locus";
                $replicon2 = "__$replicon";
                $translation = 1;
                say $out (">$strain$locus2$replicon2$total2");
                $_ =~ s/\/translation=\"//;
        	if(/\"/) { # Reset the pseudo and translation markers
            		$translation = 0;
			$test = 0;
        	}
                $_ =~ s/\"//;
                $_ =~ s/\ //g;
                print $out ("$_");
                $lengthTest = length($_);
            }
        }
        if($translation == 1 && $test == 1) {
            if(/\ /) {
        	if(/\"/) { # Reset the pseudo and translation markers
            		$translation = 0;
			$test = 0;
        	}
                $_ =~ s/\ //g;
                $_ =~ s/\"//g;
                print $out ("$_");
            }
        }
    }
    close($in);
}
close($out);
