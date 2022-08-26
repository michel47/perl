---
---
## Base26 encoding

how to convert a integer number into a word

we simple express the number in base 26 using the
alphabet: ``ABCDEFGHIJKLMNOPQRSTUVWXYZ``


```perl
#!/usr/bin/perl

# convert a number in base26 (i.e. just letters)

my $n = shift;
printf "b26: %s\n",&base26($n);

sub base26 {
  use integer;
  my $n = shift;
  my $e = '';
  #return('a') if $n == 0;
  while ( $n ) {
    my $c = $n % 26;
    $e .=  chr(0x41 + $c); # 0x41: upercase, 0x61: lowercase
    $n = int $n / 26;
  }
  return scalar reverse $e;
}

1;
```
