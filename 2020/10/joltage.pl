#!/usr/bin/perl

use v5.20;

use strict;
use warnings;

use IO::File;
use Data::Printer;

my @adapters = sort { $a <=> $b } IO::File->new('input.txt','r')->getlines;
my $current  = 0;
push @adapters, $adapters[-1] + 3;

my %differences;
while ( my $tmp = shift @adapters ) {
    $differences{$tmp-$current}++;
    $current = $tmp;
}

p %differences;

say $differences{1} * $differences{3};
