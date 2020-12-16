#!/usr/bin/perl

use v5.20;

use strict;
use warnings;

use IO::File;
use List::Util qw(sum);
use Regexp::Assemble;
use Data::Printer;

my $fh = IO::File->new('input.txt','r');
my ( $rules, $my_ticket, $other_tickets) = do{ $/ = "\n\n"; $fh->getlines };

my $ra = Regexp::Assemble->new;
for my $rule ( split /\n/, $rules ) {
    $rule =~ m{
        (?<name>\w+): \s+
        (?<first>\d+)-(?<second>\d+) \s+ or \s+
        (?<third>\d+)-(?<fourth>\d+)
    }x;

    next if !$+{first};

    $ra->add( $+{first}..$+{second}, $+{third}..$+{fourth} );
}

my $re = $ra->re;

my @error_values;
for my $ticket ( split /\n/, $other_tickets ) {
    next if $ticket eq 'nearby tickets:';

    push @error_values, grep{ $_ !~ /^$re\z/ } split /,/, $ticket;
}

say sum @error_values;
