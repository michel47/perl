---
---
## getting a word out of a number !

```perl
sub word { # 20^4 * 6^3 words (25bit worth of data ...)
 use integer;
 my $n = $_[0];
 my $vo = [qw ( a e i o u y )]; # 6
 my $cs = [qw ( b c d f g h j k l m n p q r s t v w x z )]; # 20
 my $str = '';
 $str = chr(ord('a') +$n%26);
 $n /= 26; 
 my $vnc = 1 if ($str =~ /[aeiouy]/);
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
}
```
