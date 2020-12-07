use v6;

my %rules;
my $color;

grammar BAGS {
    rule TOP { <bag-of-bags>+ }

    rule bag-of-bags {
        <color> 
        { $color = $<color>.made.trim-trailing }
        'bags contain' <contains>+ '.'
    }

    rule color {
        \w+ \w+
        { make ~$/ }
    }

    rule contains {
        <has-bags> | <no-bags>
    }

    rule no-bags {
        'no other bags'
        { %rules{$color} = {} }
    }

    rule has-bags {
        <number> <color> ['bags'|'bag'] ','?
        { %rules{$color}{$<color>.made.trim-trailing} = $<number>.made; }
    }

    rule number {
        \d+ { make ~$/; }
    }
}

my $bags = 'input.txt'.IO.slurp;
BAGS.parse( $bags );

my %seen;
my @color = 'shiny gold';
my $sum   = 0;

while ( my $check = @color.shift ) {
    my @found = %rules.keys.grep( { %rules{$_}{$check} && !%seen{$_}++ } );
    @color.append( @found );
    $sum += @found.elems;
}

say $sum;
