#!/usr/bin/perl

if ($0 eq __FILE__) {
printf "uuid: %s\n",&getuuid();
 exit $?;
}

sub getuuid {
  my $uuid = join"",map{(a..z,A..Z,0..9)[rand 62]} 0..11;
     $uuid =~ s/(....)(?<!\Z)/\1-/g; # look behind for a end-char
  return $uuid;
};


