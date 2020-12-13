#!/usr/bin/perl

use v5.20;

use strict;
use warnings;

use IO::File;
use Data::Printer;
use List::Util qw(max);
use Math::BigInt qw(blcm);

my (undef, $lines) = IO::File->new('input.txt','r')->getlines;
chomp $lines;

my (@rest) = split /,/, $lines;

my $cnt = -1; 
my %diffs  = map { 
    $cnt++;
    $_ eq 'x' ? () : ($_ => $cnt );
} @rest;

my $max  = max keys %diffs;
my $t    = $max - $diffs{$max};
my $step = $max;

BUS:
for my $bus ( sort { $b <=> $a } keys %diffs ) {
    while ( ( $t + $diffs{$bus} ) % $bus ) {
        $t += $step;
    }

    $step = blcm( $step, $bus );
}

say $t;
