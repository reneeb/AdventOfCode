#!/usr/bin/perl

use v5.20;

use strict;
use warnings;
use IO::File;
use List::Util qw(all);
use Data::Validate::WithYAML;

my $fh        = IO::File->new('./input.txt', 'r');
my $yaml      = do { local $/; <DATA> };
my $validator = Data::Validate::WithYAML->new( \$yaml );

my @passports;
{
    local $/ = "\n\n";
    while ( my $line = $fh->getline ) {
        chomp $line;
        my %data = split /[\s:]/, $line;
        push @passports, \%data if check_rules( $validator, %data );
    }
}

say scalar @passports;

sub check_rules {
    my ($validator, %data) = @_;

    my @required = qw(byr iyr eyr hgt hcl ecl pid);
    return if !all { defined $data{$_} } @required;

    for my $field ( @required ) {
        return if ! $validator->check( $field, $data{$field} );
    }

    return 1;
}

__DATA__
---
passport:
  byr:
    min: 1920
    max: 2002
  iyr:
    min: 2010
    max: 2020
  eyr:
    min: 2020
    max: 2030
  hgt:
    regex: \A(?:(1(?:[5678][0-9]|9[0123])cm)|(?:(?:59|6[0-9]|7[0-6])in))\z
  hcl:
    regex:
      - \A\#[0-9a-f]{6}\z
  ecl:
    enum:
      - amb
      - blu
      - brn
      - gry
      - grn
      - hzl
      - oth
  pid:
    regex:
      - \A[0-9]{9}\z
