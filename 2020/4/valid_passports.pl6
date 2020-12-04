use v6;

my $fh       = './input.txt'.IO.open( nl-in => "\n\n" );
my @required = <byr iyr eyr hgt hcl ecl pid>;

my $valid_passports = 0;
for $fh.lines -> $line {
    my %data = $line.split( /\s | ':'/ );
    $valid_passports++ if !@required.first: { !defined %data{$_} };
}

say $valid_passports;
