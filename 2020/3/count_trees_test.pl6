use v6;

my @rows = $=finish.lines;

my @slopes = (
      # right    # down
    ( 1,          1 ),
    ( 3,          1 ),
    ( 5,          1 ),
    ( 7,          1 ),
    ( 1,          2 ),
);

my $product = 1;
for @slopes -> @slope {
    my @map = @rows;

    if ( @slope[1] > 1 ) {
        unshift @map, "" for 1 .. ( @slope[1] - 1 );
    }

    my $col   = 0;
    my $trees = 0; 

    while ( 1 ) {
        my $row;
        $row = shift @map for 1 .. @slope[1];

        last if !$row;

        $row.chomp;
    
        if ( $col >= $row.chars ) {
            $col -= $row.chars;
        }

        my $is_tree = $row.substr-eq( '#', $col );
        $trees++ if $is_tree;
    
        print $row, "\t";
        $row.substr-rw( $col, 1 ) = 'X';
        say $row, "\t", ($is_tree ?? $trees !! '');
    
        $col += @slope[0];
    }

    say sprintf "[%s // %s] -> %s", @slope, $trees;
    $product *= $trees;

    say "\n";
}

say "Product: $product";

=finish
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
