#!/usr/bin/perl

use v5.20;

use strict;
use warnings;
use utf8;

use IO::File;
use Data::Printer;

my @map = map{
    $_ =~ s{[^L\.#]}{}gr;
} IO::File->new('input.txt','r')->getlines;

my $row_length = length $map[0];

my @checks = (
    [-1, -1], [-1, 0], [-1, 1],
    [ 0, -1],          [ 0, 1],
    [ 1, -1], [ 1, 0], [ 1, 1],
);

my $cnt = 1;
while ( 1 ) {
    say "COUNT: ", $cnt;
    $cnt++;

say np @map;

    my @map_copy = @map;
    my $has_changed;

    ROW:
    for my $row ( 0 .. $#map ) {
        my @cols = split //, $map[$row];

        for my $col ( 0 .. $#cols ) {
 
            my $seat = $cols[$col];

            next if $seat eq '.'; 

            my $free     = 0;
            my $occupied = 0;

            for my $check ( @checks ) {
                my $check_row = $row + $check->[0];

                ++$free and next if $check_row < 0;
                ++$free and next if $check_row > $#map;

                my $check_col = $col + $check->[1];

                ++$free and next if $check_col < 0;
                ++$free and next if $check_col > $#cols;

                my $check_seat = substr $map[$check_row], $check_col, 1;

                ++$free     if $check_seat eq 'L' or $check_seat eq '.';
                ++$occupied if $check_seat eq '#';
            }
           
            if ( $free == 8 && $seat eq 'L' ) {
                substr $map_copy[$row], $col, 1, '#';
                $has_changed++;
            }
            elsif ( $occupied >= 4 && $seat eq '#' ) {
                substr $map_copy[$row], $col, 1, 'L';
                $has_changed++;
            }
        }
    }
 
    @map = @map_copy;
    last if !$has_changed;
}

my $map_string     = join '', @map;
my $count_occupied = $map_string =~ tr/#//d;
say "Occupied: $count_occupied";
