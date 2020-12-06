#!/usr/bin/perl

use v5.20;
use strict;
use warnings;
use IO::File;
use Data::Printer;

my $sum = 0;

my $fh = IO::File->new('./input.txt', 'r');
local $/="\n\n";
while ( my $line = $fh->getline ) {
    chomp $line;
    $line =~ s{\n\z}{};

    my %group;
    $group{$_}++ for split //, $line;
    my $count = delete $group{"\n"} || 0;

    $sum += scalar grep{ $group{$_} == ($count+1) }keys %group;
}

say $sum;
