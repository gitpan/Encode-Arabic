# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

use 5.008;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'          => 'Encode::Arabic::ArabTeX',
    'VERSION_FROM'  => 'ArabTeX.pm',
    'PREREQ_PM'     => { 'Encode' => 1.83 * 0,
                         'Encode::Encoding' => 1.30 * 0,
                         'Encode::Mapper' => 1.16,
                         'Data::Dumper' => 2.12 * 0,
                         'Scalar::Util' => 1.07 * 0,
                         'Carp' => 1.01 * 0 },
    'ABSTRACT_FROM' => 'ArabTeX.pm',
    'AUTHOR'        => 'Otakar Smrz <smrz@ckl.mff.cuni.cz>',
);
