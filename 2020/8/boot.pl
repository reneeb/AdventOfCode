#!/usr/bin/perl

use v5.20;

use strict;
use warnings;

use IO::File;

my $fh   = IO::File->new('input.txt','r');
my @cmds = map {$_?[ split / /, $_ ]:()} $fh->getlines;

my %seen;
my $index = 0;
my $acc   = 0;
while ( 1 ) {
    my $cmd = $cmds[$index];

    say "INFINITE LOOP: $acc" and last if $seen{$index};

    $seen{$index}++;
    $index += $cmd->[1] and next if $cmd->[0] eq 'jmp';
    $acc   += $cmd->[1] if $cmd->[0] eq 'acc';
    $index++;
}

say $acc;
