# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

use 5.008;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'          => 'Encode::Arabic',
    'VERSION_FROM'  => 'Arabic.pm',
    'PREREQ_PM'     => {
                         #'Encode::Arabic::ArabTeX' => 1.35,
                         #'Encode::Arabic::ArabTeX::RE' => 1.03,
                         #'Encode::Arabic::ArabTeX::ZDMG' => 1.06,
                         #'Encode::Arabic::ArabTeX::ZDMG::RE' => 1.05,
                         #'Encode::Arabic::Buckwalter' => 1.10,
                         #'Encode' => 1.99 * 0,
                         #'Encode::Encoding' => 1.33 * 0,
                         'Encode::Mapper' => 1.18,
                         #'Exporter' => 5.57 * 0,
                         #'Data::Dumper' => 2.12 * 0,
                         #'Scalar::Util' => 1.13 * 0,
                         #'Carp' => 1.01 * 0,
                       },
    'ABSTRACT_FROM' => 'Arabic.pm',
    'AUTHOR'        => 'Otakar Smrz <smrz ckl mff cuni cz>',
);
