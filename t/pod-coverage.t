use strict;
use warnings;

use Test::More;

foreach my $module ( [ 'Test::Pod::Coverage' => 1.08 ],
                     [ 'Pod::Coverage'       => 0.18 ] ) {

    eval "use @{$module}";
    plan skip_all => "@{$module} required for testing POD coverage" if $@;
}

my @module = all_modules('lib/Encode');

plan tests => scalar @module;

foreach my $module (@module) {

    pod_coverage_ok($module, { 'trustme' => [ qr/(?:[cm]ode|options|verify|whisper)/ ] });
}
