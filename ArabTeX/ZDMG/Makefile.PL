# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

use 5.008;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'          => 'Encode::Arabic::ArabTeX::ZDMG',
    'VERSION_FROM'  => 'ZDMG.pm',
    'PREREQ_PM'     => {
                         #'Encode::Arabic::ArabTeX' => 1.34,
                         #'Encode::Encoding' => 1.33 * 0,
                         'Encode::Mapper' => 1.18,
                       },
    'ABSTRACT_FROM' => 'ZDMG.pm',
    'AUTHOR'        => 'Otakar Smrz <smrz ckl mff cuni cz>',
);
