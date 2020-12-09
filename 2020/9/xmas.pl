#!/usr/bin/perl

use v5.20;

use strict;
use warnings;

use IO::File;
use Math::Combinatorics;
use List::Util qw(first);

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
