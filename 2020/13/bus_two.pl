#!/usr/bin/perl

use v5.20;

use strict;
use warnings;

use IO::File;
use Data::Printer;
use List::Util qw(max);

my (undef, $lines) = IO::File->new('input.txt','r')->getlines;
chomp $lines;

my ($first,@rest) = split /,/, $lines;

my $cnt = 0; 
my %diffs  = map { 
    $cnt++;
    $_ eq 'x' ? () : ($_ => $cnt );
} @rest;

my $max   = max keys %diffs;
#my $timestamp = 100000000000000;
my $timestamp = 1;
my $factor    = int( $timestamp / $max );

while ( 1 ) {
    my $check = $max * $factor;
    $factor++;

    $timestamp = $check - $diffs{$max};

    next if $timestamp % $first;

    my $matched = 1;

    for my $bus ( keys %diffs ) {
        if ( ( $timestamp + $diffs{$bus} ) % $bus ) {
            $matched = 0;
            last;
        }
    }

    last if $matched;
}

say $timestamp;

for my $bus ( sort keys %diffs ) {
    say $bus, " -> ", ($timestamp + $diffs{$bus} ) / $bus;
}
