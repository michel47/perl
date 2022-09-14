#!/usr/bin/perl

my $dir = '~/knowledge/sysadm';
$dir =~ s/~/$ENV{HOME}/; # evaluation of ~ required here ~
if (-d $dir) { print "$dir is a dir !\n" }
