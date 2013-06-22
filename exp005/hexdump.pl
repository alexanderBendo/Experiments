#!/usr/bin/env perl

#
# Display the specified file in decimal or hexadecimal format
#

use strict;
use warnings;
use Getopt::Std;
use feature qw(say);

our ($opt_d, $opt_h);

getopts('dh');

my $binary_file = shift;

if ( $opt_h or not $binary_file ) {

    say 'Usage: hexdump.pl [-d] file';

    exit 1;

}

my $output_template = $opt_d ? '%02d' : '%02X';

open my $FH, '<', $binary_file or die $!;

binmode $FH;

while ( read($FH, my $byte, 1) ) {

    printf $output_template, ord $byte;

};

close $FH;
