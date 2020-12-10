use v6;

my %adapters = 'input.txt'.IO.lines.map({ $_ => 1 });
%adapters{0} = 1;
%adapters{ %adapters.keys.map({$_.Int}).max + 3 } = 1;

my %seen;

for %adapters.keys.sort({$^a <=> $^b}) -> $adapter {
    for -3 .. -1 -> $diff {
       my $predecessor = $adapter+$diff;
       if ( %adapters{$predecessor} && %seen{$predecessor} ) {
           %seen{$adapter} += %seen{$predecessor};
       }
    }

    %seen{$adapter}++ if !%seen{$adapter};
}

say %seen.values.max;
