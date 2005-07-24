# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

use 5.008;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'          => 'Encode::Arabic::ArabTeX::Verbatim',
    'VERSION_FROM'  => 'Verbatim.pm',
    'PREREQ_PM'     => {
                         #'Encode::Arabic::ArabTeX' => 1.39,
                         #'Encode::Encoding' => 1.33 * 0,
                         'Encode::Mapper' => 1.18,
                       },
    'ABSTRACT_FROM' => 'Verbatim.pm',
    'AUTHOR'        => 'Otakar Smrz <smrz ckl mff cuni cz>',
);
