use v6;

my %overwrites;
my %values;

my $max = ("0b" ~ "1" x 36).Int;

for 'input.txt'.IO.lines -> $line {
    if $line ~~ m{'mask' \s+ '=' \s+ (<[X01]>+)} {
        %overwrites = ();

        my $cnt = -1;

        for $0.split("", :skip-empty) -> $char {
            $cnt++;
            next if $char eq '0';
            %overwrites{$cnt} = $char;
        }
    }
    elsif $line ~~ m{'mem[' (\d+) ']' \s+ '=' \s+ (\d+)} {
        my $raw   = sprintf '%036b', $0;
        my $value = $1;

        for %overwrites.keys -> $pos {
            $raw.substr-rw( $pos, 1 ) = %overwrites{$pos};
        }

        my $cnt_x = $raw.comb.grep( * eq 'X' ).elems;

        my @replacements;
        @replacements[0..^$cnt_x] = (loop {<0 1>});
        for ( [X] @replacements ) -> $comb {
            my $bin = $raw;
            my $i   = 0;
            $bin ~~ s :g /'X'/{$comb[$i++]}/;
            my $dec = ('0b' ~ $bin).Int;
            %values{$dec % $max} = $value;
        }
    }
}

say sum values %values;
