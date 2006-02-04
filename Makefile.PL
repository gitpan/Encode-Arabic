# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

use 5.008;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'          => 'Encode::Arabic',
    'VERSION_FROM'  => 'Arabic.pm',
    'PREREQ_PM'     => {
                         #'Encode::Arabic::ArabTeX' => 1.42,
                         #'Encode::Arabic::ArabTeX::RE' => 1.04,
                         #'Encode::Arabic::ArabTeX::Verbatim' => 1.02,
                         #'Encode::Arabic::ArabTeX::ZDMG' => 1.08,
                         #'Encode::Arabic::ArabTeX::ZDMG::RE' => 1.06,
                         #'Encode::Arabic::Buckwalter' => 1.12,
                         #'Encode::Arabic::Parkinson' => 1.01,
                         #'Encode' => 1.99 * 0,
                         #'Encode::Encoding' => 1.33 * 0,
                         'Encode::Mapper' => 1.18,
                         #'Exporter' => 5.57 * 0,
                         #'Data::Dumper' => 2.12 * 0,
                         #'Scalar::Util' => 1.13 * 0,
                         #'Carp' => 1.01 * 0,
                       },
    'ABSTRACT_FROM' => 'Arabic.pm',
    'AUTHOR'        => 'Otakar Smrz <otakar smrz mff cuni cz>',
);
