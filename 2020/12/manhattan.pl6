use v6;

my ($x,$y,$wx,$wy) = (0,0,10,1);

grammar NAVIGATION {
    rule TOP           { [<move_forward>|<rotate>|<move_waypoint>]+  }
    rule move_forward  { 'F'<number> { my $f = $<number>.made; $x += $wx * $f; $y += $wy * $f; } }
    rule rotate        { <left>|<right> }
    rule left          { 'L'<number> {
                           my $steps = (( $<number>.made % 360 ) / 90 ).Int;
                           for 1 .. $steps {
                               ($wx,$wy) = (-$wy, $wx)
                           }
                        } }
    rule right         { 'R'<number> {
                           my $steps = (( $<number>.made % 360 ) / 90 ).Int;
                           for 1 .. $steps {
                               ($wx,$wy) = ($wy, -$wx)
                           }
                        } }
    rule move_waypoint { <north>|<east>|<south>|<west> }
    rule north         { 'N'<number> { $wy += $<number>.made } }
    rule east          { 'E'<number> { $wx += $<number>.made } }
    rule south         { 'S'<number> { $wy -= $<number>.made } }
    rule west          { 'W'<number> { $wx -= $<number>.made } }
    rule number        { \d+ { make ~$/; } }
}

my $instructions = 'input.txt'.IO.slurp;
NAVIGATION.parse( $instructions );

my $sum = $x.abs + $y.abs;
say $sum;
