#!/usr/bin/env perl

#
# Read a list of two-byte hexadecimal values from a file and create the 
# corresponding binary file
#

use strict;
use warnings;
use Getopt::Std;
use feature qw(say);

our ($opt_h, $opt_o);

getopts('ho:');

my $dump_file = shift;

if ( $opt_h or not $opt_o or not $dump_file ) {

    say 'Usage: create-binary-from-dump.pl -o output_file dump_file';

    exit 1;

}

open my $FH, '<', $dump_file or die $!;
open my $BINFILE, '>', $opt_o or die $!;

binmode $BINFILE;

while ( read($FH, my $bytes, 2) ) {

    print $BINFILE pack("H2", $bytes);

};

close $FH;
close $BINFILE;
