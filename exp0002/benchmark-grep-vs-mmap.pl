#!/usr/bin/perl

use strict;
use warnings;
use 5.010;
use utf8;
use Benchmark qw(:all);
use File::Map qw(map_file);
use autodie qw(:all);

my $suspicious_url = q{http://www.banner82.com/b.js};

my $blacklist = q{/time/url.txt};

#
# Benchmark needs a larg number of trials
#

my $count = 1000;

cmpthese(
    $count,
    {   'grep' => \&search_with_grep,
        'mmap' => \&search_with_mmap,
    }
);

sub search_with_grep {

    open my $FH, '<', $blacklist;

    while ( my $malicious_url = <$FH> ) {

        return 1 if ( $suspicious_url =~ /$malicious_url/ );

    }

    close $FH;

    return;

}

sub search_with_mmap {

    map_file my $map, $blacklist;

    return 1 if ( $map =~ /$suspicious_url/ );

    return;

}
