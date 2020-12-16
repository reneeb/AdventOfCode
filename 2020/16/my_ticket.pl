#!/usr/bin/perl

use v5.24;

use strict;
use warnings;

use IO::File;
use List::Util qw(product first);
use Regexp::Assemble;
use Data::Printer;

my $fh = IO::File->new('input.txt','r');
my ( $rules, $my_ticket, $other_tickets) = do{ $/ = "\n\n"; $fh->getlines };

my %rule_map;
my $ra = Regexp::Assemble->new;
for my $rule ( split /\n/, $rules ) {
    $rule =~ m{
        (?<name>[\w ]+): \s+
        (?<first>\d+)-(?<second>\d+) \s+ or \s+
        (?<third>\d+)-(?<fourth>\d+)
    }x;

    next if !defined $+{first};

    $ra->add( $+{first}..$+{second}, $+{third}..$+{fourth} );

    $rule_map{$+{name}} = {
        first    => $+{first},
        second   => $+{second},
        third    => $+{third},
        fourth   => $+{fourth},
    }
}

my $re = $ra->re;

my @values    = split /,/, ( split /\n/, $my_ticket )[-1];
my %position = map{ $_ => +{ map{ $_ => 1 }keys %rule_map } } ( 0 .. $#values );

for my $ticket ( split /\n/, $other_tickets ) {
    next if $ticket eq 'nearby tickets:';

    my @fields = split /,/, $ticket;
    my @error_values = grep{ $_ !~ /^$re\z/ } @fields;;
    if ( @error_values ) {
        next;
    }

    for my $index ( 0 .. $#fields ) {
       for my $rule ( sort keys $position{$index}->%* ) { 
            my $val              = $fields[$index];
            my $is_in_boundaries = (
                ( $val >= $rule_map{$rule}->{first} && $val <= $rule_map{$rule}->{second} ) ||
                ( $val >= $rule_map{$rule}->{third} && $val <= $rule_map{$rule}->{fourth} )
            );

            if ( !$is_in_boundaries ) {
                delete $position{$index}->{$rule};
            }
       }
    }
}

my %route_map;
while ( 1 ) {
    my @position_keys = keys %position;

    last if !@position_keys;

    for my $pos ( sort keys %position ) {
        my @keys = keys $position{$pos}->%*;

        if ( 1 == @keys ) {
            delete $position{$_}->{$keys[0]} for keys %position;
            delete $position{$pos};
            $route_map{$keys[0]} = $pos;
        }
    }
}

say product
    map{ my $pos = $route_map{$_}; $values[$pos] }
    grep{ $_ =~ m{^departure} }
    keys %route_map;
