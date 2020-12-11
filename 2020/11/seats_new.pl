#!/usr/bin/perl

use v5.20;

use strict;
use warnings;
use utf8;

use IO::File;
use List::Util qw(first);
use Data::Printer;

my @map = map{
    $_ =~ s{[^L\.#]}{}gr;
} IO::File->new('input.txt','r')->getlines;

my $row_length = length $map[0];
my $map_string = join '', @map;
my $map_length = length $map_string;

my @checks = (
    ($row_length+1) * -1, $row_length * -1, ($row_length-1) * -1,
    -1,                                     +1,
    $row_length-1,        $row_length,      $row_length+1,
);

while ( 1 ) {
    my $map_copy = $map_string;
    my $has_changed;

    for my $index ( 0 .. $map_length ) {
        my $seat = substr $map_string, $index, 1;

        next if $seat eq '.'; 
        next if !$seat;

        my $free     = 0;
        my $occupied = 0;

        my @tmp_checks = @checks;

        if ( $index % $row_length == 0 ) {
            $free += 3;
            @tmp_checks = @checks[1, 2, 4, 6, 7];
        }
        elsif ( $index % $row_length == ( $row_length - 1 ) ) {
            $free += 3;
            @tmp_checks = @checks[0, 1, 3, 5, 6];
        }

        for my $check ( @tmp_checks ) {
            my $factor = 1;
            my $check_seat;

            while ( 1 ) {
                my $check_index = $index + ( $check * $factor++ );

                $check_seat     = (
                    $check_index < 0 ||
                    $check_index >= $map_length 
                ) ? 'oom' :  substr $map_string, $check_index, 1;

                my $next_move_oom = ( abs($check) != $row_length ) && (
                    ( $check_index % $row_length == 0 ) ||
                    ( $check_index % $row_length == ( $row_length - 1 ) )
                );

                $check_seat = 'oom' if $check_seat eq '.' && $next_move_oom;

                last if $check_seat ne '.';
            }

            ++$free     if first{ $check_seat eq $_ }qw(L . oom);
            ++$occupied if $check_seat eq '#';
        }
       
        if ( $free == 8 && $seat eq 'L' ) {
            substr $map_copy, $index, 1, '#';
            $has_changed++;
        }
        elsif ( $occupied >= 5 && $seat eq '#' ) {
            substr $map_copy, $index, 1, 'L';
            $has_changed++;
        }
    }

    $map_string = $map_copy;
    last if !$has_changed;
}

my $count_occupied = $map_string =~ tr/#//d;
say "Occupied: $count_occupied";
