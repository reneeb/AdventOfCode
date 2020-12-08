#!/usr/bin/perl

use v5.20;

use strict;
use warnings;

use IO::File;
use Data::Printer;

my $fh    = IO::File->new('input.txt','r');
my @lines = $fh->getlines;

my %changed;

OUTER:
while ( 1 ) {
    my @cmds = map {$_?[ split / /, $_ ]:()} @lines;

    my %seen;
    my $index    = 0;
    my $acc      = 0;
    my $is_fixed = 0;

    INNER:
    while ( 1 ) {
        my $cmd = $cmds[$index];

        last INNER if !$cmd;

        if ( $cmd->[0] =~ m{jmp|nop} && !$changed{$index} && !$is_fixed ) {
            $cmd->[0] = $cmd->[0] eq 'jmp' ? 'nop' : 'jmp';
            say "fixed line $index to $cmd->[0]";
            $is_fixed = 1;
            $changed{$index}++;
        }

        say "INFINITE LOOP: $acc" and next OUTER if $seen{$index};

        $seen{$index}++;
        $index += $cmd->[1] and next INNER if $cmd->[0] eq 'jmp';
        $acc   += $cmd->[1] if $cmd->[0] eq 'acc';
        $index++;
    }

    say $acc;
    last;
}
