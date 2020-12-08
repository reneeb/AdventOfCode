use v6;

my @cmds = 'input.txt'.IO.lines.map({ $_.words } );

my %seen;
my $index = 0;
my $acc   = 0;

while ( 1 ) {
    my ($cmd,$val) = @cmds[$index].cache;

    say "INFINITE LOOP: $acc" and last if %seen{$index};

    %seen{$index}++;
    $index += $val and next if $cmd eq 'jmp';
    $acc   += $val if $cmd eq 'acc';
    $index++;
}
