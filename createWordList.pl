#!/usr/bin/perl;

###################################
#
#	createWordList.pl
#
#	author:		Brad Wolfe
#	version:	0.1
#
#	notes:		This script takes an exported sitemap in text format and 
#				outputs a wordlist of unique words used. This is an early
#				version, so expect some issue from time to time.  If you
#				come across anything, pleae feel free to let me know. 
#
###################################
use strict;
use warnings;

if  (eval {require List::MoreUtils;1;} ne 1) {
	die "\nYou will need to install the List::MoreUtils module from cpan to continue.\n\n".
		"sudo cpan install List::MoreUtils\n\n";
}
else{
use List::MoreUtils qw(uniq);
}


#	vars
my $numArgs = $#ARGV + 1;
my @wordList = ();


#	Parse through the text and remove any of the undesirable characters and 
#	split the remaining text into an array of words.  Push that array into 
#	what will become our final wordlist.

sub pText{

	my $url = $_;

	$url =~ s/^HTTPS:\/\///ig;
	$url =~ s/^HTTP:\/\///ig;
	$url =~ s/\?.*$//ig;
	$url =~ s/\// /ig;
	$url =~ s/\./ /ig;
	$url =~ s/-/ /ig;
	
	my @temp = split(' ',$url);
	
	foreach(@temp){
		push(@wordList,$_);
	}
}

#	Check to make sure that we have exactly one argument when running the script.

if ($numArgs <= 0){die "you must input a filename\n";}

if ($numArgs > 1){die "you must input ONE filename, you have entered $numArgs\n";}


#	Once we have determined that there is only one argument, we will ensure that 
#	the desired file actually exists.

my $inputFile = $ARGV[0];

if (! -e $inputFile){die "file does not exist\n";}


#	Now that we know it exists, we will try to open the file.  If it can't
#	be opened, the script will die.

open iFILE, $inputFile or die "Could not open the file: $inputFile\n";;

my @lines = <iFILE>;

foreach (@lines){
	pText($_);
}


#	Clean up the list by ordering and removing duplicates
#	Then output to standard out.  By doing this, the user can 
#		choose to output to a file using > or >> <filename> when
#		running the script to either create or append to a text file.

@wordList = sort @wordList;

@wordList = uniq @wordList;

foreach (@wordList){
	print $_."\n";
}

close iFILE;
#	fin
