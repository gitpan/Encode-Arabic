# ##################################################################### Otakar Smrz, 2003/08/05
#
# Encoding of Arabic: ArabTeX Notation by Klaus Lagally, ZDMG #################################

# $Id: ZDMG.pm,v 1.5 2003/09/08 18:57:19 smrz Exp $

package Encode::Arabic::ArabTeX::ZDMG;

use 5.008;

use strict;
use warnings;

use Carp;

our $VERSION = do { my @r = q$Revision: 1.5 $ =~ /\d+/g; sprintf "%d." . "%02d" x $#r, @r };


use Encode::Arabic::ArabTeX ();
use base 'Encode::Arabic::ArabTeX';


use Encode::Encoding;
use base 'Encode::Encoding';

__PACKAGE__->Define('arabtex-zdmg', 'ArabTeX-ZDMG');


use Encode::Mapper ':others', ':silent', ':join';


# no strict 'refs';
# print @{ __PACKAGE__ . '::ISA' }, "...";


sub import {            # perform import as if Encode were used one level before this module

    if (defined $_[1] and $_[1] eq ':xml') {    # interfere little with possible Encode's options

        Encode::Mapper->options (

            'override' => [             # override rules of these LHS .. no other tricks ^^

                    (                   # combinations of '<' and '>' with the other bytes
                        map {

                            my $x = chr $_;

                            "<" . $x, [ "<" . $x, ">" ],    # propagate the '>' sign implying ..
                            ">" . $x, [ $x, ">" ],          # .. preservation of the bytes

                        } 0x00..0x3B, 0x3D, 0x3F..0xFF
                    ),

                        ">>",           ">",                # stop the whole process ..
                        "<>",           "<>",               # .. do not even start it

                        "><",           [ "<", ">" ],       # rather than nested '<' and '>', ..
                        "<<",           [ "<<", ">" ],

                        ">\\<",         [ "<", ">" ],       # .. prefer these escape sequences
                        ">\\\\",        [ "\\", ">" ],
                        ">\\>",         [ ">", ">" ],

                        ">",            ">",                # singular symbols may migrate right ..
                        "<",            "<",                # .. or preserve the rest of the data
                ]

            );

        splice @_, 1, 1;
    }

    require Encode;

    Encode->export_to_level(1, @_);     # here comes the only trick ^^
}


sub encoder ($;%) {
    my ($cls, %opt) = @_;

    my $encoder = [];


    $encoder->[0] = Encode::Mapper->compile (

                [
                    'silent' => 0,
                ],

                    "\x{0054}",         "\\cap t",          "\x{0074}",         "t",
                    "\x{1E6E}",         "\\cap _t",         "\x{1E6F}",         "_t",
                    "\x{0044}",         "\\cap d",          "\x{0064}",         "d",
                    "\x{1E0E}",         "\\cap _d",         "\x{1E0F}",         "_d",
                    "\x{0052}",         "\\cap r",          "\x{0072}",         "r",
                    "\x{005A}",         "\\cap z",          "\x{007A}",         "z",
                    "\x{0053}",         "\\cap s",          "\x{0073}",         "s",
                    "\x{0160}",         "\\cap ^s",         "\x{0161}",         "^s",
                    "\x{1E62}",         "\\cap .s",         "\x{1E63}",         ".s",
                    "\x{1E0C}",         "\\cap .d",         "\x{1E0D}",         ".d",
                    "\x{1E6C}",         "\\cap .t",         "\x{1E6D}",         ".t",
                    "\x{1E92}",         "\\cap .z",         "\x{1E93}",         ".z",
                    "\x{004C}",         "\\cap l",          "\x{006C}",         "l",
                    "\x{004E}",         "\\cap n",          "\x{006E}",         "n",

                    # "\x{0054}",         "\\cap T",          "\x{0074}",         "T",
                    # "\x{004E}",         "\\cap N",          "\x{006E}",         "N",
                    # "\x{0057}",         "\\cap W",          "\x{0077}",         "W",

                    "\x{0041}",         "\\cap a",          "\x{0061}",         "a",
                    "\x{0045}",         "\\cap e",          "\x{0065}",         "e",
                    "\x{0049}",         "\\cap i",          "\x{0069}",         "i",
                    "\x{004F}",         "\\cap o",          "\x{006F}",         "o",
                    "\x{0055}",         "\\cap u",          "\x{0075}",         "u",
                    "\x{0100}",         "\\cap A",          "\x{0101}",         "A",
                    "\x{0112}",         "\\cap E",          "\x{0113}",         "E",
                    "\x{012A}",         "\\cap I",          "\x{012B}",         "I",
                    "\x{014C}",         "\\cap O",          "\x{014D}",         "O",
                    "\x{016A}",         "\\cap U",          "\x{016B}",         "U",

                    "\x{02BC}",         "\"",
                    "\x{02BE}",         "'",
                    "\x{02BF}",         "`",

                    "\x{0042}",         "\\cap b",          "\x{0062}",         "b",
                    "\x{01E6}",         "\\cap ^g",         "\x{01E7}",         "^g",
                    "\x{1E24}",         "\\cap .h",         "\x{1E25}",         ".h",
                    "\x{1E2A}",         "\\cap _h",         "\x{1E2B}",         "_h",
                    "\x{0120}",         "\\cap .g",         "\x{0121}",         ".g",
                    "\x{0046}",         "\\cap f",          "\x{0066}",         "f",
                    "\x{0051}",         "\\cap q",          "\x{0071}",         "q",
                    "\x{004B}",         "\\cap k",          "\x{006B}",         "k",
                    "\x{004D}",         "\\cap m",          "\x{006D}",         "m",
                    "\x{0048}",         "\\cap h",          "\x{0068}",         "h",
                    "\x{0057}",         "\\cap w",          "\x{0077}",         "w",
                    "\x{0059}",         "\\cap y",          "\x{0079}",         "y",

                    "\x{0050}",         "\\cap p",          "\x{0070}",         "p",
                    "\x{0056}",         "\\cap v",          "\x{0076}",         "v",
                    "\x{0047}",         "\\cap g",          "\x{0067}",         "g",

                    "\x{0043}",         "\\cap c",          "\x{0063}",         "c",
                    "\x{010C}",         "\\cap ^c",         "\x{010D}",         "^c",
                    "\x{0106}",         "\\cap ,c",         "\x{0107}",         ",c",
                    "\x{017D}",         "\\cap ^z",         "\x{017E}",         "^z",
                    "\x{00D1}",         "\\cap ^n",         "\x{00F1}",         "^n",
                    "\x{004C}\x{0303}", "\\cap ^l",         "\x{006C}\x{0303}", "^l",
                    "\x{0052}\x{0307}", "\\cap .r",         "\x{0072}\x{0307}", ".r",

            );


    no strict 'refs';

    return ${ $cls . '::encoder' } = $encoder;
}


sub decoder ($;$$) {
    my ($cls, undef, undef) = @_;

    my $decoder = [];


    my @sunny = (
                    [ "t",           "\x{0054}",    "\x{0074}" ],
                    [ "_t",          "\x{1E6E}",    "\x{1E6F}" ],
                    [ "d",           "\x{0044}",    "\x{0064}" ],
                    [ "_d",          "\x{1E0E}",    "\x{1E0F}" ],
                    [ "r",           "\x{0052}",    "\x{0072}" ],
                    [ "z",           "\x{005A}",    "\x{007A}" ],
                    [ "s",           "\x{0053}",    "\x{0073}" ],
                    [ "^s",          "\x{0160}",    "\x{0161}" ],
                    [ ".s",          "\x{1E62}",    "\x{1E63}" ],
                    [ ".d",          "\x{1E0C}",    "\x{1E0D}" ],
                    [ ".t",          "\x{1E6C}",    "\x{1E6D}" ],
                    [ ".z",          "\x{1E92}",    "\x{1E93}" ],
                    [ "l",           "\x{004C}",    "\x{006C}" ],
                    [ "n",           "\x{004E}",    "\x{006E}" ],
                );


    my @extra = (
                    [ "T",           "\x{0054}",    "\x{0074}" ],
                    [ "N",           "\x{004E}",    "\x{006E}" ],
                    [ "W",           "\x{0057}",    "\x{0077}" ],
                );


    my @vowel = (
                    [ "a",           "\x{0041}",    "\x{0061}" ],
                    [ "_a",          "\x{0100}",    "\x{0101}" ],
                    [ "_aA",         "\x{0100}",    "\x{0101}" ],
                    [ "_aY",         "\x{0100}",    "\x{0101}" ],
                    [ "_aU",         "\x{0100}",    "\x{0101}" ],
                    [ "_aI",         "\x{0100}",    "\x{0101}" ],
                    [ "e",           "\x{0045}",    "\x{0065}" ],
                    [ "i",           "\x{0049}",    "\x{0069}" ],
                    [ "_i",          "\x{012A}",    "\x{012B}" ],
                    [ "o",           "\x{004F}",    "\x{006F}" ],
                    [ "u",           "\x{0055}",    "\x{0075}" ],
                    [ "_u",          "\x{016A}",    "\x{016B}" ],
                    [ "A",           "\x{0100}",    "\x{0101}" ],
                    [ "^A",          "\x{0100}",    "\x{0101}" ],
                    [ "_A",          "\x{0100}",    "\x{0101}" ],
                    [ "E",           "\x{0112}",    "\x{0113}" ],
                    [ "I",           "\x{012A}",    "\x{012B}" ],
                    [ "^I",          "\x{012A}",    "\x{012B}" ],
                    [ "O",           "\x{014C}",    "\x{014D}" ],
                    [ "U",           "\x{016A}",    "\x{016B}" ],
                    [ "^U",          "\x{016A}",    "\x{016B}" ],
                    [ "_U",          "\x{0055}",    "\x{0075}" ],
                    [ "Y",           "\x{0100}",    "\x{0101}" ],
                );


    my @minor = (
                    [ "'",           "\x{02BE}" ],  # "\x{02BC}"
                    [ "`",           "\x{02BF}" ],  # "\x{02BB}"
                );


    my @moony = (
                    [ "b",           "\x{0042}",    "\x{0062}" ],
                    [ "^g",          "\x{01E6}",    "\x{01E7}" ],
                    [ ".h",          "\x{1E24}",    "\x{1E25}" ],
                    [ "_h",          "\x{1E2A}",    "\x{1E2B}" ],
                    [ ".g",          "\x{0120}",    "\x{0121}" ],
                    [ "f",           "\x{0046}",    "\x{0066}" ],
                    [ "q",           "\x{0051}",    "\x{0071}" ],
                    [ "k",           "\x{004B}",    "\x{006B}" ],
                    [ "m",           "\x{004D}",    "\x{006D}" ],
                    [ "h",           "\x{0048}",    "\x{0068}" ],
                    [ "w",           "\x{0057}",    "\x{0077}" ],
                    [ "y",           "\x{0059}",    "\x{0079}" ],

                    [ "p",           "\x{0050}",    "\x{0070}" ],
                    [ "v",           "\x{0056}",    "\x{0076}" ],
                    [ "g",           "\x{0047}",    "\x{0067}" ],

                    [ "c",           "\x{0043}",    "\x{0063}" ],   # .ha with hamza
                    [ "^c",          "\x{010C}",    "\x{010D}" ],   # gim with three
                    [ ",c",          "\x{0106}",    "\x{0107}" ],   # _ha with three
                    [ "^z",          "\x{017D}",    "\x{017E}" ],   # zay with three
                    [ "^n",          "\x{00D1}",    "\x{00F1}" ],   # kaf with three
                    [ "^l",          "\x{004C}\x{0303}",    "\x{006C}\x{0303}" ],   # lam with a bow above
                    [ ".r",          "\x{0052}\x{0307}",    "\x{0072}\x{0307}" ],   # ra' with a bow below
                );


    $decoder->[0] = Encode::Mapper->compile (

                [
                    'silent' => 0,
                ],

                    "\"",               "\x{02BC}",

                # definite article assimilation
                (
                    map {

                        "l-" . $_->[0] x 2, [ '', $_->[0] . "-" . $_->[0] ],

                    } @sunny
                ),

                # initial vowel tying
                (
                    map {

                        my $x = $_;

                        map {

                            my $y = $_;

                            map {

                                $x->[0] . $_ . $y, $x->[2] . $_ . "\x{02BC}",  # "\x{02C8}"

                                "\\cap\x09" . $x->[0] . $_ . $y, $x->[1] . $_ . "\x{02BC}",  # "\x{02C8}"
                                "\\cap\x0A" . $x->[0] . $_ . $y, $x->[1] . $_ . "\x{02BC}",  # "\x{02C8}"
                                "\\cap\x0D" . $x->[0] . $_ . $y, $x->[1] . $_ . "\x{02BC}",  # "\x{02C8}"
                                "\\cap\x20" . $x->[0] . $_ . $y, $x->[1] . $_ . "\x{02BC}",  # "\x{02C8}"

                            } "-", "\x09", "\x0A", "\x0D", "\x20", "\x0D\x0A",
                              "\x20\x20", "\x20\x20\x20", "\x20\x20\x20\x20"

                        } "a", "e", "i", "o", "u"

                    } @vowel
                ),

                # silence the silent

                    "WA",           [ "", "W" ],
                    "UA",           [ "", "U" ],
                    "NA",           [ "", "N" ],
                    "NY",           [ "", "N" ],
                    "NU",           [ "", "N" ],
                    "N_A",          [ "", "N" ],

                # regular capitalization
                (
                    map {

                        $_->[0], $_->[2],

                        "\\cap\x09" . $_->[0], $_->[1],
                        "\\cap\x0A" . $_->[0], $_->[1],
                        "\\cap\x0D" . $_->[0], $_->[1],
                        "\\cap\x20" . $_->[0], $_->[1],

                    } @sunny, @moony, @vowel, @extra
                ),

                # capitalization of minors
                (
                    map {

                        $_->[0], $_->[1],

                        "\\cap\x09" . $_->[0], [ $_->[1], "\\cap " ],
                        "\\cap\x0A" . $_->[0], [ $_->[1], "\\cap " ],
                        "\\cap\x0D" . $_->[0], [ $_->[1], "\\cap " ],
                        "\\cap\x20" . $_->[0], [ $_->[1], "\\cap " ],

                    } @minor
                ),

                # white-space collapsing
                (
                    map {

                        "\\cap\x09" . $_, [ '', "\\cap " ],
                        "\\cap\x0A" . $_, [ '', "\\cap " ],
                        "\\cap\x0D" . $_, [ '', "\\cap " ],
                        "\\cap\x20" . $_, [ '', "\\cap " ],

                    } "\x09", "\x0A", "\x0D", "\x20"
                ),

            );


    no strict 'refs';

    return ${ $cls . '::decoder' } = $decoder;
}


1;

__END__


=head1 NAME

Encode::Arabic::ArabTeX::ZDMG - ZDMG phonetic transcription of Arabic using the ArabTeX notation

=head1 REVISION

    $Revision: 1.5 $        $Date: 2003/09/08 18:57:19 $


=head1 SYNOPSIS

    use Encode::Arabic::ArabTeX::ZDMG;  # imports just like 'use Encode' would, plus extended options

    while ($line = <>) {                # maps the ArabTeX notation for Arabic into the Latin symbols

        print encode 'utf8', decode 'arabtex-zdmg', $line;      # 'arabtex-zdmg' alias 'ArabTeX-ZDMG'
    }

    # ArabTeX lower ASCII transliteration <--> Latin phonetic transcription, ZDMG style

    $string = decode 'ArabTeX-ZDMG', $octets;
    $octets = encode 'ArabTeX-ZDMG', $string;

    Encode::Arabic::ArabTeX->encoder('dump' => '!./encoder.code');  # dump the encoder engine to file
    Encode::Arabic::ArabTeX->decoder('load');   # load the decoder engine from module's extra sources


=head1 DESCRIPTION

ArabTeX is an excellent extension to TeX/LaTeX designed for typesetting the right-to-left scripts of
the Orient. It comes up with very intuitive and comprehensible lower ASCII transliterations, the
expressive power of which is even better than that of the scripts.

L<Encode::Arabic::ArabTeX::ZDMG|Encode::Arabic::ArabTeX::ZDMG> implements the rules needed for proper
interpretation of the ArabTeX notation of Arabic into the phonetic transcription in the ZDMG style.
The conversion ifself is done by L<Encode::Mapper|Encode::Mapper>, and the user interface is built
on the L<Encode::Encoding|Encode::Encoding> module.

Relevant guidance is given in L<Encode::Arabic::ArabTeX|Encode::Arabic::ArabTeX>, from which this module
inherits. The transformation rules are, however, quite different ;)


=head1 SEE ALSO

L<Encode::Arabic::ArabTeX|Encode::Arabic::ArabTeX>,
L<Encode::Arabic|Encode::Arabic>,
L<Encode::Mapper|Encode::Mapper>,
L<Encode::Encoding|Encode::Encoding>,
L<Encode|Encode>

ArabTeX system      L<ftp://ftp.informatik.uni-stuttgart.de/pub/arabtex/arabtex.htm>

Klaus Lagally       L<http://www.informatik.uni-stuttgart.de/ifi/bs/people/lagall_e.htm>

Arabeyes Arabic Unix Project    L<http://www.arabeyes.org>


=head1 AUTHOR

Otakar Smrz, L<http://ckl.mff.cuni.cz/smrz/>

    eval { 'E<lt>' . 'smrz' . "\x40" . ( join '.', qw 'ckl mff cuni cz' ) . 'E<gt>' }

Perl is also designed to make the easy jobs not that easy ;)


=head1 COPYRIGHT AND LICENSE

Copyright 2003 by Otakar Smrz

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut
