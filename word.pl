#!/usr/bin/perl

#  my $n = uint64(~0);
#  printf "%-2d: %19x, %19s\n",64,$n,&word(~0);
#
#18446744073709551615
# pabokyrulafivacanud
#
for my $i (0 .. 64) {
  my $o = ~0;
  my $n = ~($o<<$i);
  my $word = &word("$n");
  printf "%-2d: %20u, %19s\n",$i,$n,$word;
}

if (@ARGV) {
  printf "%s: %s\n",$ARGV[0],&word($ARGV[0]);
}

exit $?;


sub word { # 20^4 * 6^3 words (25bit worth of data ...)
  use Math::Int64 qw(uint64);
  my $n = uint64($_[0]);
  my $vo = [qw ( a e i o u y )]; # 6
  my $cs = [qw ( b c d f g h j k l m n p q r s t v w x z )]; # 20
  my $str = '';
  $str = chr(ord('a') +$n%26);
  $n /= 26;
  my $vnc = ($str =~ /[aeiouy]/) ? 1 : 0;
  while ($n > 0) {
    if ($vnc) {
      my $c = $n % 20;
      $n /= 20;
      $str .= $cs->[$c];
      $vnc = 0;
      #print "cs: $n -> $c -> $str\n";
    } else {
      my $c = $n % 6;
      $n /= 6;
      $str .= $vo->[$c];
      $vnc = 1;
      #print "vo: $n -> $c -> $str\n";
    }
  }
  return $str;
}

