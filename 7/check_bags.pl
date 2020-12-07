#!/usr/bin/perl

use v5.20;

use strict;
use warnings;

use IO::File;
use Data::Printer;

my %rules;

my $fh = IO::File->new('./input.txt','r');
while ( my $line = $fh->getline ) {
    my ($color, $other_colors) = $line =~ m{
        ^(.*) \s+ bags \s+ contain \s+ (.*)\.
    }xms;

    if ( $other_colors eq 'no other bags' ) {
        $rules{$color} = {};
        next;
    }

    my @found = $other_colors =~ m{(\d+) \s+ (.*?) \s+ bag}xmsg;
    $rules{$color} = { reverse @found };
}

my %seen;
my @color = 'shiny gold';
my $sum   = 0;

while ( my $check = shift @color ) {
    my @found = grep { $rules{$_}->{$check} && !$seen{$_}++ } keys %rules;

    push @color, @found;
    $sum += scalar @found;
}

say $sum;
