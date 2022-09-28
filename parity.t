#!/usr/bin/perl

my $intent = 'compute even-parity of a data string';

# see BIP39 checksum : https://bitcoin.stackexchange.com/questions/110451/how-to-properly-compute-the-bip39-checksum-bytes

my $i = 0x45f7_132b;
my $s = pack'N',$i;
my $b = unpack'b*',$s;
my $o = $b; $o =~ tr/1//dc;
printf "h: %x\n",$i;
printf "N: %s\n",unpack'H*',$s;
printf "b: %s\n",$b;
printf "o: %s (%d.)\n",$o,length($o);
my $p = unpack'%1b*',$i; # parity-bit
printf "p: %d\n",$p;

exit;
