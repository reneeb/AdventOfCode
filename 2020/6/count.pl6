use v6;

my $sum_anyone   = 0;
my $sum_everyone = 0;

my $fh       = './input.txt'.IO.open( nl-in => "\n\n", chomp => True );
for $fh.lines -> $origline {
    my $line = $origline.subst(/\s+$/,"");

    my %group;
    %group{$_}++ for $line.split("", :skip-empty);
    my $count = %group{"\n"}:delete || 0;

    $sum_anyone   +=  %group.keys;
    $sum_everyone +=  %group.keys.grep({ %group{$_} == ($count+1) });
}

say "Anyone: $sum_anyone";
say "Everyone: $sum_everyone";
