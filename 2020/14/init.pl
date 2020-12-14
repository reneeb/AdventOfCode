#!/usr/bin/perl

use v5.20;

use strict;
use warnings;

use IO::File;
use List::Util qw(sum);
use Math::BigInt;

my $fh = IO::File->new('input.txt', 'r');

my %overwrites;
my %values;

my $max = Math::BigInt->from_bin( 1 x 36 );

while ( my $line = $fh->getline ) {
    if ( $line =~ m{mask = ([X01]+)} ) {
        my $cnt = -1;
        %overwrites = map{ $cnt++; $_ eq 'X' ? () : ($cnt => $_) } split //, $1;
    }
    else {
        my ($mem, $value) = $line =~ m{mem\[(\d+)\] \s+ = \s+ (\d+)}x;
        my $bin = sprintf '%036b', $value;
        substr $bin, $_, 1, $overwrites{$_} for keys %overwrites;
        my $dec = Math::BigInt->from_bin( $bin );
        $values{$mem % $max} = $dec . "";
    }
}

say sum values %values;
