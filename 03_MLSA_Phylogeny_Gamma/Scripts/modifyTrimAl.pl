#!usr/bin/perl
use File::Find;
use 5.010;
use Cwd;

$pwd = cwd();
$parent = "$pwd/Trimal";
$output = "$pwd/TrimalModified/";

find( \&search_all_folder, $parent );

sub search_all_folder {
	chomp $_;
	return if $_ eq '.' or $_ eq '..';
	&read_files ($_) if (-f);
}

sub read_files {
	($filename) = @_;
	open $fh, '<', $filename;
	$output2 = $output . $filename;
	open($out,'>',$output2);
	while(<$fh>) {
		if(/>/) {
			chomp;
			@line = split("\ ",$_);
			@line2 = split('__',$_);
			print $out ("\n@line2[0],@line[1],");
		}
		else {
			chomp;
			print $out ($_);
		}
	}
	close($fh);
	close($out);
}
