#!/usr/bin/perl

use v5.24;

use strict;
use warnings;

use IO::File;

use feature 'postderef';

my @instructions = map{ chomp $_; [ $_ =~ m{([A-Z]+)(\d+)}] } IO::File->new('input.txt','r')->getlines;

my %distances = ( qw/N 0 E 0 S 0 W 0/ );

my %directions = (
    N => ['W','E'],
    E => ['N','S'],
    S => ['E','W'],
    W => ['S','N'],
);

my $current = 'E';

while ( my $next = shift @instructions ) {
    my ($cmd,$value) = $next->@*;

    $distances{$cmd}     += $value if $directions{$cmd};
    $distances{$current} += $value if $cmd eq 'F';

    if ( $cmd eq 'L' or $cmd eq 'R' ) {
        my $index = $cmd eq 'L' ? 0 : 1;

        while ( $value ) {
           $current = $directions{$current}->[$index];
           $value -= 90; 
        }
    }
}

my $sum = (
    abs( $distances{N} - $distances{S} ) +
    abs( $distances{E} - $distances{W} )
);

say $sum;
