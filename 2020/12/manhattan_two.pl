#!/usr/bin/perl

use v5.24;

use strict;
use warnings;

use IO::File;
use Data::Printer;
use List::Util qw(first);

use feature 'postderef', 'signatures';
no warnings 'experimental::signatures';

my @instructions = map{ chomp $_; [ $_ =~ m{([A-Z]+)(\d+)}] } IO::File->new('input.txt','r')->getlines;

my ($x, $y)    = (0, 0);
my ($wy, $wx)  = (1, 10);

my %move_waypoint = (
    N => sub ($v) { $wy += $v },
    E => sub ($v) { $wx += $v },
    S => sub ($v) { $wy -= $v },
    W => sub ($v) { $wx -= $v },
);

my %rotate = (
    R => sub { ($wx, $wy) = ($wy, -$wx) },
    L => sub { ($wx, $wy) = (-$wy, $wx) },
);

while ( my $next = shift @instructions ) {
    my ($cmd,$value) = $next->@*;

    if ( $cmd eq 'F' ) {
        $x += $wx * $value;
        $y += $wy * $value;
    }
    elsif ( first { $cmd eq $_ } qw(N E S W) ) {
        $move_waypoint{$cmd}->($value);
    }
    elsif ( $cmd eq 'L' or $cmd eq 'R' ) {
        my $factor  = $cmd eq 'L' ? 1 : -1;
        my $steps   = int( ( $value % 360 ) / 90 );

        next if !$steps;
        $rotate{$cmd}->() for 1 .. $steps;
    }
}

my $sum = abs( $x ) + abs( $y );
say $sum;
