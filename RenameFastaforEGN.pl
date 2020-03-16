#!/usr/bin/perl
#use strict;

########################################
#	Script for concatenating several fasta files in a given directory 
#	and attribute a unique identifier to each sequence
#	Will create bigfile.fasta and All.xls.
########################################

my $count = 1;
my $basedir="$ARGV[0]";
opendir(DIR,"$basedir") or die "Error : wrong folder !\n";
open(XLS, ">All.xls") or die;

open(OUT, ">bigfile.fasta") or die;
while (my $file = readdir(DIR))
{
	next if (($file eq '.') or ($file eq '..'));
	print "\tAdding $file\n";
	open(IN, "<$basedir\/$file") or die "Cannot open $file\n";
	$file=~s/\.fna$|\.fasta$|\.fa$//g;
	while (my $line = <IN>) 
	{
		chomp $line;
		if ($line =~ /^\>(.*)$/)
		{
			my $temptxt = sprintf('>gi|%010d|ref|xxx|function	%s	[%s]', $count, $1, $file);
			my $temp = sprintf('>gi|%010d|ref|xxx|function [%s]', $count, $file);
			print OUT "$temp\n";
			print XLS "$temptxt\n";
			$count++;
		}
		else
		{
			print OUT "$line\n";
		}
	}
	close(IN);
}
close(XLS);
close(OUT);
closedir(DIR);
print("".($count-1)." sequences added\n");
