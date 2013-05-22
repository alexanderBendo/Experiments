#!perl

use strict;
use warnings;
use 5.010;

#
# Given a list of strings, try to create a hash of named parameters
#

#
# Main
#

my @params = qw/param1=value1 param2=value2 test_param_1=GIVEN_VALUE_1/;

init_hash(@params);

say "-" x 80;

init_hash_shorter(@params);

#
# Subs
#

sub init_hash {

    my (@params) = @_;

    my @param_value_pairs = map { split /=/, $_ } @params;

    my $hash = {
        test_param_1 => 'test_value_1',
        test_param_2 => 'test_value_2',
        @param_value_pairs,
    };

    while ( my ($k,$v) = each %{ $hash } ) {
        say "$k = $v";
    }

}

sub init_hash_shorter {

    my $hash = { map { split /=/, $_ } @_ };

    while ( my ($k,$v) = each %{ $hash } ) {
        say "$k = $v";
    }

}
