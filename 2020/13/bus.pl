#!/usr/bin/perl

use v5.20;

use strict;
use warnings;

use IO::File;
use Data::Printer;
use List::Util qw(min first);

my ($timestamp, $lines) = IO::File->new('input.txt','r')->getlines;

my @busses = grep{ $_ ne 'x' } split /,/, $lines;
my %diffs  = map { 
    my $wait = ( $_ * ( int( $timestamp / $_ ) + 1 ) ) - $timestamp;
    $wait => $_;
} @busses;


my $min  = min keys %diffs;
my $prod = $min * $diffs{$min};
say $prod;
