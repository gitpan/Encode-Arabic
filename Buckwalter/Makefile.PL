# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

use 5.008;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'          => 'Encode::Arabic::Buckwalter',
    'VERSION_FROM'  => 'Buckwalter.pm',
    'PREREQ_PM'     => {
                         #'Encode' => 1.99 * 0,
                         #'Encode::Encoding' => 1.33 * 0,
                         #'Scalar::Util' => 1.13 * 0,
                       },
    'ABSTRACT_FROM' => 'Buckwalter.pm',
    'AUTHOR'        => 'Otakar Smrz <otakar smrz mff cuni cz>',
);
