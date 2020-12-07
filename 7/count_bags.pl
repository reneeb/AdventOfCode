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

my $sum = for_color( 'shiny gold', \%rules);

sub for_color {
    my ($check, $rules) = @_;

    my %contains = %{ $rules->{$check} };

    return 0 if !%contains;

    my $sum = 0;

    for my $color ( keys %contains ) {
        my $count = $contains{$color};

        $sum += $count;
        $sum += $count * for_color( $color, $rules );
    }

    return $sum;
}

say $sum;
