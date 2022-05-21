---
---
## weighted list in perl

This code snippet allow you to assigne weight to a list
(all passed by references)

```perl
#!/usr/bin/perl

use YAML::XS qw(Dump);

my $weight = {};
my $crypt = [ qw( SOL BTC ETH MYC ) ];
my $w     = [ qw( 0.1 0.5 0.1 0.3 ) ];
@{$weight}{@{$crypt}} = @{$w};
printf "weight: %s...\n",Dump($weight);
exit $?
```
