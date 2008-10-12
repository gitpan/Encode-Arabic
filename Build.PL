use Module::Build;

use strict;
use warnings;

my $build = Module::Build->new(
    module_name         => 'Encode::Arabic',
    license             => 'perl',
    dist_author         => 'Otakar Smrz <otakar smrz mff cuni cz>',
    dist_version_from   => 'lib/Encode/Arabic.pm',
    requires       => {
                           'perl'           => 5.008,
                      },
    build_requires => {
                           'Test::More'     => 0,
                      },
    add_to_cleanup      => [ 'Encode-Arabic-*' ],
);

$build->create_build_script();