#!/usr/bin/perl

use v5.20;

use strict;
use warnings;

use IO::File;

my @adapters_list = sort { $a <=> $b } IO::File->new('input.txt','r')->getlines;
my $max = $adapters_list[-1] + 3;
push @adapters_list, $max;
unshift @adapters_list, 0;

my %adapters = map{ chomp $_; $_+0 => 1 }@adapters_list;

my %seen;

for my $adapter ( @adapters_list ) {
    for my $diff ( -3 .. -1 ) {
       my $predecessor = $adapter+$diff;
       if ( $adapters{$predecessor} && $seen{$predecessor} ) {
           $seen{$adapter} += $seen{$predecessor};
       }
    }

    $seen{$adapter}++ if !$seen{$adapter};
}

say $seen{$max};
