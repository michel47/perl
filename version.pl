#!/usr/bin/perl

my $dbug = 1;
my $file = shift || __FILE__;
my @ver = &version($file);
printf "file: %s\n",$file;
printf qq'version: "%.2f - %s"\n',@ver;
my ($m,$r) = &rev(time);
printf qq'scheduled: "v%.1f.%d" # (%s+%s)\n',int($m/10)/10,$m%10+$r,$m,$r;
exit $?;

# -----------------------------------------------------------------------
sub fdow {
   my $tic = shift;
   use Time::Local qw(timelocal);
   ##     0    1     2    3    4     5     6     7
   #y ($sec,$min,$hour,$day,$mon,$year,$wday,$yday)
   my $year = (localtime($tic))[5]; my $yr4 = 1900 + $year ;
   my $first = timelocal(0,0,0,1,0,$yr4);
   $fdow = (localtime($first))[6];
   #printf "1st: %s -> fdow: %s\n",&hdate($first),$fdow;
   return $fdow;
}
# -----------------------------------------------------------------------
sub version {
  #y ($atime,$mtime,$ctime) = (lstat($_[0]))[8,9,10];
  my @times = sort { $a <=> $b } (lstat($_[0]))[9,10]; # ctime,mtime
  my $etime = (sort { $a <=> $b } (@times))[0];
  my $vtime = $times[-1]; # biggest time...
  printf "etime: %d\n",$etime;
  my $version = &rev($etime);

  if (wantarray) {
     my $shk = &get_shake(160,$_[0]);
     printf "$_[0]: shk:%s\n",unpack'H*',$shk if $dbug;
     my $pn = unpack('n',substr($shk,-7,6)); # 40-bit
     my $build = &word($pn);
     return ($version, $build);
  } else {
     return sprintf '%g',$version;
  }
}
# -----------------------------------------------------
sub get_shake { # use shake 256 because of ipfs' minimal length of 20Bytes
  use Crypt::Digest::SHAKE;
  my $len = shift;
  local *F; open F,$_[0] or do { warn qq{"$_[0]": $!}; return undef };
  #binmode F unless $_[0] =~ m/\.txt/;
  my $msg = Crypt::Digest::SHAKE->new(256);
  $msg->addfile(*F);
  my $digest = $msg->done(($len+7)/8);
  return $digest;
}
# -----------------------------------------------------
# max word: pabokyrulafivacanud QmVMDSybz4hQnEvxc5PrKqNS7osvLHADgifaZ3PXcJh9PF
sub word { # 20^4 * 6^3 + 20^3*6^4 words (25.4bit worth of data ...)
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
# -----------------------------------------------------------------------
sub rev {
  my ($sec,$min,$hour,$mday,$mon,$yy,$wday,$yday) = (localtime($_[0]))[0..7];
  my $rweek=($yday+&fdow($_[0]))/7;
  my $rev_id = int($rweek) * 4;
  my $low_id = int(($wday+($hour/24)+$min/(24*60))*4/7);
  my $revision = ($rev_id + $low_id) / 100;
  return (wantarray) ? ($rev_id,$low_id) : $revision;
}
# -----------------------------------------------------------------------

