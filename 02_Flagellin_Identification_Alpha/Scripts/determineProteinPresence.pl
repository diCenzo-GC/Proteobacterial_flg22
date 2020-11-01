#!usr/bin/perl
use 5.010;

# List of files
$strainFile = 'Input_files/genomeList.txt';
$nodA_file = 'HMMscanTop/Flagellin_N.csv';

# Prepare lists of strain/species names
open($strainList,'<',$strainFile);
while(<$strainList>) {
	chomp;
	@strainLine = split("\t",$_);
	@strainLine2 = split('_',@strainLine[0]);
	$partialStrain = "@strainLine2[0]_@strainLine2[1]";
	push(@strainsFull,@strainLine[0]);
	push(@strainsPartial,$partialStrain);
	push(@species,$partialStrain);
}

# Determine presence of the six genes
say("Strain\tFlagellin");
$count = -1;
foreach $i (@strainsFull) {
	$count++;
	@hitArray = qw( 0 );
	open($nodA,'<',$nodA_file);
	while(<$nodA>) {
		if(/$i/) {
			@line = split(',',$_);
			if(@line[9] eq 'Flagellin_N') {
				@hitArray[0] = '1';
			}
			elsif(@line[9] eq 'Flagellin_C') {
				@hitArray[0] = '1';
			}
                        elsif(@line[9] eq 'PRK12687') {
                                @hitArray[0] = '1';
                        }
		}
	}
	close($nodA);
	say("@strainsFull[$count]\t@hitArray[0]");
}
