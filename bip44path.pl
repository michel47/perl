#!/usr/bin/perl


my $path = "m/44/501'/0/0";
my @segments = split('/',$path); shift @segments;
  for my $segment ( @segments ) {
    if ($segment =~ m/'$/) {
      $segment = 0 + substr($segment,0,-1);
      $hardened = 1;
    } else {
      $hardened = 0;
    }
      printf "segment: %s%s\n",$segment,($hardened)?'h':'';
  }
