#!/usr/bin/perl

use v5.20;

use strict;
use warnings;
use IO::File;

my $factor  = 8;
my $max_id  = 0;

my $fh = IO::File->new( './input.txt', 'r' );
while ( my $line = $fh->getline ) {
    my @chars = split //, $line;

    my @rows = ( 0 .. 127 );
    for ( 0 .. 6 ) {
        splice @rows, $#rows/2 + 1, $#rows if $chars[$_] eq 'F';
        splice @rows, 0, $#rows/2 + 1      if $chars[$_] eq 'B';
    }

    my @cols = ( 0 .. 7 );
    for ( 7 .. 9 ) {
        splice @cols, int ($#cols/2) + 1, $#cols if $chars[$_] eq 'L';
        splice @cols, 0, int( $#cols/2 + 1)      if $chars[$_] eq 'R';
    }

    my $product = $rows[0] * $factor + $cols[0];

    chomp $line;
    say "$line -> $product";

    $max_id = $product if $product > $max_id;
}

say "Max ID: $max_id";
