# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

use 5.008;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'          => 'Encode::Arabic::ArabTeX::ZDMG::RE',
    'VERSION_FROM'  => 'RE.pm',
    'PREREQ_PM'     => { 'Encode' => 1.83 * 0,
                         'Encode::Encoding' => 1.30 * 0 },
    'ABSTRACT_FROM' => 'RE.pm',
    'AUTHOR'        => 'Otakar Smrz <smrz@ckl.mff.cuni.cz>',
);
