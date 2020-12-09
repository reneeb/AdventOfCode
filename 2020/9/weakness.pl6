use v6;

my @numbers = 'input.txt'.IO.lines;

my $preamble = 25;
my $index    = $preamble;
my $found;

while $index <= @numbers.elems {
    my $pair = @numbers[($index-$preamble)..^$index].combinations(2).grep( -> @pair {@numbers[$index] == [+] @pair});

    if ( !$pair ) {
        $found = @numbers[$index];
        say $found;
        last;
    }

    $index++;
}

my $start = 0;

OUTERH:
while @numbers[$start] != $found  {
    my $sum = 0;
    my @added;

    for @numbers[$start..^@numbers.elems] -> $num {
        $sum += $num;
        @added.push( $num );

        last if $sum > $found;

        if ( $sum == $found ) {
            say @added.join(',') ~ ' -> ' ~ @added.min + @added.max;
            last OUTERH;
        }
    }

    $start++;
}
