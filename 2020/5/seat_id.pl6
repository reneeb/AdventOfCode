use v6;

my $factor  = 8;
my $max_id  = 0;

my $fh       = './input.txt'.IO.open;
for $fh.lines -> $line {
    my @rows = ( 0 .. 127 );
    for ( 0 .. 6 ) {
        @rows.splice: (@rows.end / 2 + 1).Int, @rows.end if $line.substr-eq( 'F', $_ );
        @rows.splice: 0, (@rows.end / 2 + 1).Int         if $line.substr-eq( 'B', $_ );
    }

    my @cols = ( 0 .. 7 );
    for ( 7 .. 9 ) {
        @cols.splice: (@cols.end / 2 + 1).Int, @cols.end if $line.substr-eq( 'L', $_ );
        @cols.splice: 0, (@cols.end / 2 + 1).Int         if $line.substr-eq( 'R', $_ );
    }

    my $product = @rows[0] * $factor + @cols[0];

    say "$line -> $product";

    $max_id = $product if $product > $max_id;
}

say "Max ID: $max_id";
