#!/usr/bin/perl

use v5.20;

use strict;
use warnings;

use IO::File;
use List::Util qw(sum);
use Math::BigInt;
use Set::CrossProduct;
use Data::Printer;

my $fh = IO::File->new('input.txt', 'r');

my %overwrites;
my %values;

my $max = Math::BigInt->from_bin( 1 x 36 );

while ( my $line = $fh->getline ) {
    if ( $line =~ m{mask = ([X01]+)} ) {
        my $cnt = -1;
        %overwrites = map{ $cnt++; $_ eq '0' ? () : ($cnt => $_) } split //, $1;
    }
    else {
        my ($mem, $value) = $line =~ m{mem\[(\d+)\] \s+ = \s+ (\d+)}x;
        my $raw = sprintf '%036b', $mem;
        substr $raw, $_, 1, $overwrites{$_} for keys %overwrites;
        my $cnt_x = $raw =~ tr/X//;

        my @combinations = Set::CrossProduct->new( [ ([0,1]) x $cnt_x ] )->combinations;
        for my $comb ( @combinations ) {
            my $bin = $raw;
            $bin =~ s{X}{shift @{$comb}}eg;
            my $dec = Math::BigInt->from_bin( $bin );
            $values{$dec % $max} = $value;
        }
    }
}

say sum values %values;
