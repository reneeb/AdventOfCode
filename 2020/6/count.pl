#!/usr/bin/perl

use v5.20;
use strict;
use warnings;
use IO::File;

my $sum = 0;

my $fh = IO::File->new('./input.txt', 'r');
local $/="\n\n";
while ( my $line = $fh->getline ) {
    $line =~ s{\s}{}g;
    my %group = map{ $_ => 1 } split //, $line;

    say scalar keys %group;
    $sum += scalar keys %group;
}

say $sum;
