# Cpanel::JSON::XS
read: http://blogs.perl.org/users/e_choroba/2018/03/numbers-and-strings-in-json.html
```perl
#!/usr/bin/perl

# intent preserving integer type while
#  converting from json/yaml to obj and back
#  - use Cpanel::JSON:XS;
#  - use YAML::XS;

use YAML::Tiny qw();
use YAML::Syck qw();
use YAML::XS qw();
use JSON::XS qw();
use Cpanel::JSON::XS qw();
#integer: 25
#string: "25"
#float: 25.0
#boolean: Yes
my $float=$$ + 0.24;
my $json = sprintf'{"integer":%u,"string":"%s","float":%0.2f,"boolean":true}',$float,$float,$float;
my $obj = Cpanel::JSON::XS::decode_json($json);
my $buf = YAML::XS::Dump($obj);
printf "--- # buf: %s---\n",$buf;
$obj = YAML::XS::Load($buf);


printf "json.xs: %s\n",JSON::XS::encode_json($obj);
printf "json.cpanel: %s\n",Cpanel::JSON::XS::encode_json($obj);
printf "--- # yaml: %s...\n",YAML::XS::Dump($obj);
printf "--- # yaml.syck %s...\n",YAML::Syck::Dump($obj);
printf "--- # yaml.tiny: %s...\n",YAML::Tiny::Dump($obj);

exit $?;
## read more: http://blogs.perl.org/users/e_choroba/2018/03/numbers-and-strings-in-json.html
```