#!/usr/bin/perl

use v5.20;

use strict;
use warnings;

use IO::File;
use Math::Combinatorics;
use List::Util qw(first min max);

my @numbers = IO::File->new('input.txt','r')->getlines;

my $preamble = 25;
my $index    = $preamble;
my $found;

while ( $index <= $#numbers ) {
    my @pairs = combine( 2, @numbers[ ($index-$preamble) .. ($index-1) ] );
    my $pair  = first{ ($_->[0] + $_->[1]) == $numbers[$index] } @pairs;
    if ( !$pair ) {
        $found = $numbers[$index];
        say $found;
        last;
    }

    $index++;
}

my $start = 0;

OUTER:
while ( $numbers[$start] != $found ) {
    my $sum = 0;
    my @added;

    for my $num ( @numbers[$start..$#numbers] ) {
        $sum += $num;
        push @added, $num;

        if ( $sum == $found ) {
            say join ', ', @added;
            say min( @added ) + max(@added);
            last OUTER;
        }
    }

    $start++;
}
