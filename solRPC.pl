#!/usr/bin/perl

my $api_host='https://api.devnet.solana.com';
my $url = $api_host . '';
use YAML::XS qw(Dump);

local $/ = undef;
#my $json = <STDIN>;

my $owner = 'Fg2RSRChcR5m1x8wTJWYbA1GD6kcKytcQM12kDNApf37';

my $json = <<EOT;
{
   "jsonrpc": "2.0",
    "id": 1,
    "method": "getTokenAccountsByOwner",
    "params": [
      "$owner",
      { "mint": "treessKmT2gWMhn2hiQ5QMuTPCdCLZ3wpVdE3SUB8Yp" },
      { "encoding": "jsonParsed" }
    ]
}
EOT
&post_obj($url,$json);



exit $?;


sub post_obj {
   # https://stackoverflow.com/questions/3836526/how-do-i-send-post-data-with-lwp
   # https://idqna.madreview.net/
   use LWP::UserAgent qw();

   my $url = shift;
   my $data = shift;
   my $ua = LWP::UserAgent->new();
   my $req = HTTP::Request->new( 'POST', $url );
      $req->header( 'Content-Type' => 'application/json' );
      $req->content( $data );
      my $ua = LWP::UserAgent->new;
      my $resp = $ua->request( $req );
      my $resp = $ua->request( $req );

#   my $form = [
#       You are allowed to use a CODE reference as content in the request object passed in.
#       The content function should return the content when called. The content can be returned
#       Content => [$filepath, $filename, Content => $data ]
#        'file-to-upload' => ["$filepath" => "$filename", Content => "$data" ]
#     ];

   #my $resp = $ua->post($url,$form, [ Content => "$json" ] );
   if ($resp->is_success()) {
     use JSON::XS qw(decode_json);
     my $content;
     $content = $resp->content();
     my $obj = &decode_json($content);
     printf "--- resp: %s...\n",&decode_json($resp);
   } else {
     printf "ERROR: %s\n", $response->status_line(); 
     $obj = { "message" => "error", "status" => $status };
   }

   return $obj;
}

sub get_obj {
   my $url = shift;
   my $content = '400 Error';
   if ( iscached($url) ) {
     $content = get_cache($url);
   } else {
     use LWP::Simple qw(get);
     $content = get $url;
     warn "Couldn't get $url" unless defined $content;
     set_cache($url,$content);
   }
   my $obj = &objectify($content);
   return $obj;
}

sub objectify {
  my $content = shift;
  use JSON::XS qw(decode_json);
  if ($content =~ m/\}\n\{/m) { # nd-json format (stream)
    my $resp = [ map { &decode_json($_) } split("\n",$content) ] ;
    return $resp;
  } elsif ($content =~ m/^{/ || $content =~ m/^\[/) { # plain json]}
    #printf "[DBUG] Content: %s\n",$content;
    my $resp = &decode_json($content);
    return $resp;
  } elsif ($content =~ m/^--- /) { # /!\ need the trailing space
    use YAML::XS qw(Load);
    my $resp = Load($content);
    return $resp;
  } else {
    return $content;
  }
}

sub khash { # keyed hash
   use Crypt::Digest qw();
   my $alg = shift;
   my $data = join'',@_;
   my $msg = Crypt::Digest->new($alg) or die $!;
      $msg->add($data);
   my $hash = $msg->digest();
   return $hash;
}

sub iscached {
  my $url = shift;
  my $hash = &khash('SHA1','GET '.$url);
  my $file = sprintf 'cached/%s.dat',unpack'H*',$hash;
  if (-e $file) {
     my @times = sort { $a <=> $b } (lstat($file))[9,10]; # ctime,mtime
     my $elapsed = (time - $times[-1]);
     printf "elapsed: %d\n",$elapsed;
     return ($elapsed <  300 * 60) ? 1 : 0; # 5hr cache
  } else {
  return 0; # cache miss
  }
}
sub get_cache {
  my $url = shift;
  my $hash = &khash('SHA1','GET '.$url);
  my $file = sprintf 'cached/%s.dat',unpack'H*',$hash;
  printf "use-cache: %s\n",$file;
  my $content = &readfile($file);
  return $content;
}
sub set_cache {
  my $url = shift;
  my $data = shift;
  my $hash = &khash('SHA1','GET '.$url);
  my $file = sprintf 'cached/%s.dat',unpack'H*',$hash;
  my $status = &writefile($file,$data);
  return $status;
}

sub readfile { # Ex. my $content = &readfile($filename);
  #y $intent = "read a (simple) file";
  my $file = shift;
  if (! -e $file) {
    print "// Error: readfile.file: ! -e $file\n";
    return undef;
  }
  local *F; open F,'<',$file; binmode(F);
  local $/ = undef;
  my $buf = <F>;
  close F;
  return $buf;
}

sub writefile { # Ex. &writefile($filename, $data1, $data2);
  #y $intent = "write a (simple) file";
  my $file = shift;
  local *F; open F,'>',$file; binmode(F);
  print "# // storing file: $file\n";
  for (@_) { print F $_; }
  close F;
  return $.;
}
1;
