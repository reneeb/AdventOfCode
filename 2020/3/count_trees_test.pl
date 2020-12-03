#!/usr/bin/perl

use strict;
use warnings;

my @rows = <DATA>;
my @slopes = (
      # right    # down
    [ 1,          1 ],
    [ 3,          1 ],
    [ 5,          1 ],
    [ 7,          1 ],
    [ 1,          2 ],
);

my $product = 1;
for my $slope ( @slopes ) {
    my @map = @rows;
    if ( $slope->[1] > 1 ) {
        unshift @map, "" for 1 .. ( $slope->[1] - 1 );
    }

    my $col   = 0;
    my $trees = 0; 

    while ( 1 ) {
        my $row;
        $row = shift @map for 1 .. $slope->[1];

        last if !$row;

        chomp $row;
    
        if ( $col >= length $row ) {
            $col -= length $row;
        }
    
        my $field = substr $row, $col, 1;
        $trees++ if $field eq '#';
    
        print $row, "\t";
        substr $row, $col, 1, 'X';
        print $row, "\t", ($field eq '#' ? $trees : ''), "\n";
    
        $col += $slope->[0];
    }

    print sprintf "[%s // %s] -> %s\n", @{ $slope }, $trees;
    $product *= $trees;

    print "\n\n";
}

print "Product: $product\n";

__DATA__
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
