#!/usr/bin/perl

use v5.24;

use strict;
use warnings;

use IO::File;

my @starting = split /,/, IO::File->new('input.txt','r')->getline;
chomp @starting;

my $cnt    = 1;
my %spoken = map{ $_ => +{ last => $cnt++ } }@starting;

my $check  = $starting[-1];
while ( $cnt <= 30_000_000 ) {
    say $cnt if $cnt % 100_000 == 0;
    if ( defined $spoken{$check}->{previous} ) {
        $check = $spoken{$check}->{last} - $spoken{$check}->{previous};
    }
    else {
        $check = 0;
    }

    my $last = $spoken{$check}->{last};
    $spoken{$check} = +{
        previous => $last,
        last     => $cnt,
    };

    $cnt++;
} 

say $check;
