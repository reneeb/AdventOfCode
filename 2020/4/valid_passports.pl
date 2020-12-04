#!/usr/bin/perl

use v5.20;

use strict;
use warnings;
use IO::File;
use List::Util qw(all);

my $fh       = IO::File->new('./input.txt', 'r');
my @required = qw(byr iyr eyr hgt hcl ecl pid);

my @passports;
{
    local $/ = "\n\n";
    while ( my $line = $fh->getline ) {
        chomp $line;
        my %data = split /[\s:]/, $line;
        push @passports, \%data if all { defined $data{$_} } @required;
    }
}

say scalar @passports;
