# ##################################################################### Otakar Smrz, 2003/01/23
#
# Encoding of Arabic: ArabTeX Notation by Klaus Lagally ############################ 2003/06/19

# $Id: ArabTeX.pm,v 1.18 2003/09/08 14:43:14 smrz Exp $

package Encode::Arabic::ArabTeX;

use 5.008;

use strict;
use warnings;

use Scalar::Util 'blessed';
use Carp;

our $VERSION = do { my @r = q$Revision: 1.18 $ =~ /\d+/g; sprintf "%d." . "%02d" x $#r, @r };


use Encode::Encoding;
use base 'Encode::Encoding';

__PACKAGE__->Define('arabtex', 'ArabTeX');


use Encode::Mapper ':others', ':silent', ':join';


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


sub encode ($$;$) {
    my ($cls, $text, $check) = @_;

    $cls = blessed $cls if ref $cls;

    no strict 'refs';

    $cls->encoder() unless defined ${ $cls . '::encoder' };

    return Encode::Mapper->encode($text, ${ $cls . '::encoder' }, undef);
}


sub decode ($$;$) {
    my ($cls, $text, $check) = @_;

    $cls = blessed $cls if ref $cls;

    no strict 'refs';

    $cls->decoder() unless defined ${ $cls . '::decoder' };

    return Encode::Mapper->decode($text, ${ $cls . '::decoder' }, 'utf8');
}


sub encoder ($;%) {
    my $cls = shift @_;

    my $encoder = $cls->eecoder('encoder', @_);

    return $encoder unless defined $encoder and $encoder == -1;

    $encoder = [];


    $encoder->[0] = Encode::Mapper->compile (

                [
                    'silent' => 0,
                ],

                    "\x{064B}",     "aN",           # 240 "\xF0", # "\xD9\x8B" <aN>
                    "\x{064C}",     "uN",           # 241 "\xF1", # "\xD9\x8C" <uN>
                    "\x{064D}",     "iN",           # 242 "\xF2", # "\xD9\x8D" <iN>
                    "\x{064E}",     "a",            # 243 "\xF3", # "\xD9\x8E" <a>
                    "\x{064F}",     "u",            # 245 "\xF5", # "\xD9\x8F" <u>
                    "\x{0650}",     "i",            # 246 "\xF6", # "\xD9\x90" <i>
                    "\x{0670}",     "_a",
                    "\x{0657}",     "_u",
                    "\x{0656}",     "_i",

                    "\x{060C}",     ",",            # 161 "\xA1", # "\xD8\x8C" right-to-left-comma
                    "\x{061B}",     ";",            # 186 "\xBA", # "\xD8\x9B" right-to-left-semicolon
                    "\x{061F}",     "?",            # 191 "\xBF", # "\xD8\x9F" right-to-left-question-mark
                    "\x{0621}",     "'",            # 193 "\xC1", # "\xD8\xA1" hamza-on-the-line
                    "\x{0622}",     "'A",           # 194 "\xC2", # "\xD8\xA2" madda-over-'alif
                    "\x{0623}",     "'",            # 195 "\xC3", # "\xD8\xA3" hamza-over-'alif
                    "\x{0624}",     "'",            # 196 "\xC4", # "\xD8\xA4" hamza-over-waaw
                    "\x{0625}",     "'",            # 197 "\xC5", # "\xD8\xA5" hamza-under-'alif
                    "\x{0626}",     "'",            # 198 "\xC6", # "\xD8\xA6" hamza-over-yaa'
                    "\x{0627}",     "A",            # 199 "\xC7", # "\xD8\xA7" bare 'alif
                    "\x{0628}",     "b",            # 200 "\xC8", # "\xD8\xA8" <b>
                    "\x{0629}",     "T",            # 201 "\xC9", # "\xD8\xA9" <T>
                    "\x{062A}",     "t",            # 202 "\xCA", # "\xD8\xAA" <t>
                    "\x{062B}",     "_t",           # 203 "\xCB", # "\xD8\xAB" <_t>
                    "\x{062C}",     "^g",           # 204 "\xCC", # "\xD8\xAC" <^g>
                    "\x{062D}",     ".h",           # 205 "\xCD", # "\xD8\xAD" <.h>
                    "\x{062E}",     "_h",           # 206 "\xCE", # "\xD8\xAE" <_h>
                    "\x{062F}",     "d",            # 207 "\xCF", # "\xD8\xAF" <d>
                    "\x{0630}",     "_d",           # 208 "\xD0", # "\xD8\xB0" <_d>
                    "\x{0631}",     "r",            # 209 "\xD1", # "\xD8\xB1" <r>
                    "\x{0632}",     "z",            # 210 "\xD2", # "\xD8\xB2" <z>
                    "\x{0633}",     "s",            # 211 "\xD3", # "\xD8\xB3" <s>
                    "\x{0634}",     "^s",           # 212 "\xD4", # "\xD8\xB4" <^s>
                    "\x{0635}",     ".s",           # 213 "\xD5", # "\xD8\xB5" <.s>
                    "\x{0636}",     ".d",           # 214 "\xD6", # "\xD8\xB6" <.d>
                    "\x{0637}",     ".t",           # 216 "\xD8", # "\xD8\xB7" <.t>
                    "\x{0638}",     ".z",           # 217 "\xD9", # "\xD8\xB8" <.z>
                    "\x{0639}",     "`",            # 218 "\xDA", # "\xD8\xB9" <`>
                    "\x{063A}",     ".g",           # 219 "\xDB", # "\xD8\xBA" <.g>
                    "\x{0640}",     "--",           # 220 "\xDC", # "\xD9\x80" ta.twiil
                    "\x{0641}",     "f",            # 221 "\xDD", # "\xD9\x81" <f>
                    "\x{0642}",     "q",            # 222 "\xDE", # "\xD9\x82" <q>
                    "\x{0643}",     "k",            # 223 "\xDF", # "\xD9\x83" <k>
                    "\x{0644}",     "l",            # 225 "\xE1", # "\xD9\x84" <l>
                    "\x{0645}",     "m",            # 227 "\xE3", # "\xD9\x85" <m>
                    "\x{0646}",     "n",            # 228 "\xE4", # "\xD9\x86" <n>
                    "\x{0647}",     "h",            # 229 "\xE5", # "\xD9\x87" <h>
                    "\x{0648}",     "w",            # 230 "\xE6", # "\xD9\x88" <w>
                    "\x{0649}",     "Y",            # 236 "\xEC", # "\xD9\x89" 'alif maq.suura
                    "\x{064A}",     "y",            # 237 "\xED", # "\xD9\x8A" <y>
                    "\x{0651}",     "\\shadda{}",   # 248 "\xF8", # "\xD9\x91" ^sadda
                  # "\x{0652}",     '"',            # 250 "\xFA", # "\xD9\x92" sukuun
                    "\x{0652}",     "",             # 250 "\xFA", # "\xD9\x92" sukuun
                    "\x{0671}",     "A",            # 199 "\xC7", # "\xD9\xB1" wa.sla-on-'alif

                    "\x{067E}",     "p",
                    "\x{06A4}",     "v",
                    "\x{06AF}",     "g",

                    "\x{0681}",     "c",
                    "\x{0686}",     "^c",
                    "\x{0685}",     ",c",
                    "\x{0698}",     "^z",
                    "\x{06AD}",     "^n",
                    "\x{06B5}",     "^l",
                    "\x{0695}",     ".r",

                    "\x{0628}\x{0651}",  "bb",           # 200 "\xC8", # "\xD8\xA8" <b>
                    "\x{062A}\x{0651}",  "tt",           # 202 "\xCA", # "\xD8\xAA" <t>
                    "\x{062B}\x{0651}",  "_t_t",         # 203 "\xCB", # "\xD8\xAB" <_t>
                    "\x{062C}\x{0651}",  "^g^g",         # 204 "\xCC", # "\xD8\xAC" <^g>
                    "\x{062D}\x{0651}",  ".h.h",         # 205 "\xCD", # "\xD8\xAD" <.h>
                    "\x{062E}\x{0651}",  "_h_h",         # 206 "\xCE", # "\xD8\xAE" <_h>
                    "\x{062F}\x{0651}",  "dd",           # 207 "\xCF", # "\xD8\xAF" <d>
                    "\x{0630}\x{0651}",  "_d_d",         # 208 "\xD0", # "\xD8\xB0" <_d>
                    "\x{0631}\x{0651}",  "rr",           # 209 "\xD1", # "\xD8\xB1" <r>
                    "\x{0632}\x{0651}",  "zz",           # 210 "\xD2", # "\xD8\xB2" <z>
                    "\x{0633}\x{0651}",  "ss",           # 211 "\xD3", # "\xD8\xB3" <s>
                    "\x{0634}\x{0651}",  "^s^s",         # 212 "\xD4", # "\xD8\xB4" <^s>
                    "\x{0635}\x{0651}",  ".s.s",         # 213 "\xD5", # "\xD8\xB5" <.s>
                    "\x{0636}\x{0651}",  ".d.d",         # 214 "\xD6", # "\xD8\xB6" <.d>
                    "\x{0637}\x{0651}",  ".t.t",         # 216 "\xD8", # "\xD8\xB7" <.t>
                    "\x{0638}\x{0651}",  ".z.z",         # 217 "\xD9", # "\xD8\xB8" <.z>
                    "\x{0639}\x{0651}",  "``",           # 218 "\xDA", # "\xD8\xB9" <`>
                    "\x{063A}\x{0651}",  ".g.g",         # 219 "\xDB", # "\xD8\xBA" <.g>
                    "\x{0641}\x{0651}",  "ff",           # 221 "\xDD", # "\xD9\x81" <f>
                    "\x{0642}\x{0651}",  "qq",           # 222 "\xDE", # "\xD9\x82" <q>
                    "\x{0643}\x{0651}",  "kk",           # 223 "\xDF", # "\xD9\x83" <k>
                    "\x{0644}\x{0651}",  "ll",           # 225 "\xE1", # "\xD9\x84" <l>
                    "\x{0645}\x{0651}",  "mm",           # 227 "\xE3", # "\xD9\x85" <m>
                    "\x{0646}\x{0651}",  "nn",           # 228 "\xE4", # "\xD9\x86" <n>
                    "\x{0647}\x{0651}",  "hh",           # 229 "\xE5", # "\xD9\x87" <h>
                    "\x{0648}\x{0651}",  "ww",           # 230 "\xE6", # "\xD9\x88" <w>
                    "\x{064A}\x{0651}",  "yy",           # 237 "\xED", # "\xD9\x8A" <y>

            );


    no strict 'refs';

    return ${ $cls . '::encoder' } = $encoder;
}


sub decoder ($;$$) {
    my $cls = shift @_;

    my $decoder = $cls->eecoder('decoder', @_);

    return $decoder unless defined $decoder and $decoder == -1;

    $decoder = [];


    my @sunny = (
                    [ "t",           "\x{062A}" ],              # "\xD8\xAA" <t>
                    [ "_t",          "\x{062B}" ],              # "\xD8\xAB" <_t>
                    [ "d",           "\x{062F}" ],              # "\xD8\xAF" <d>
                    [ "_d",          "\x{0630}" ],              # "\xD8\xB0" <_d>
                    [ "r",           "\x{0631}" ],              # "\xD8\xB1" <r>
                    [ "z",           "\x{0632}" ],              # "\xD8\xB2" <z>
                    [ "s",           "\x{0633}" ],              # "\xD8\xB3" <s>
                    [ "^s",          "\x{0634}" ],              # "\xD8\xB4" <^s>
                    [ ".s",          "\x{0635}" ],              # "\xD8\xB5" <.s>
                    [ ".d",          "\x{0636}" ],              # "\xD8\xB6" <.d>
                    [ ".t",          "\x{0637}" ],              # "\xD8\xB7" <.t>
                    [ ".z",          "\x{0638}" ],              # "\xD8\xB8" <.z>
                    [ "l",           "\x{0644}" ],              # "\xD9\x84" <l>
                    [ "n",           "\x{0646}" ],              # "\xD9\x86" <n>
                );


    my @empty = (
                    [ "|",           ""         ],              # ArabTeX's "invisible consonant"
                    [ "",            "\x{0627}" ],              # "\xD8\xA7" bare 'alif
                );


    my @taaaa = (
                    [ "T",           "\x{0629}" ],              # "\xD8\xA9" <T>
                );


    my @moony = (
                    [ "'A",          "\x{0622}" ],              # "\xD8\xA2" madda-over-'alif
                    [ "'a",          "\x{0623}" ],              # "\xD8\xA3" hamza-over-'alif
                    [ "'i",          "\x{0625}" ],              # "\xD8\xA5" hamza-under-'alif
                    [ "'w",          "\x{0624}" ],              # "\xD8\xA4" hamza-over-waaw
                    [ "'y",          "\x{0626}" ],              # "\xD8\xA6" hamza-over-yaa'
                    [ "'|",          "\x{0621}" ],              # "\xD8\xA1" hamza-on-the-line
                    [ "b",           "\x{0628}" ],              # "\xD8\xA8" <b>
                    [ "^g",          "\x{062C}" ],              # "\xD8\xAC" <^g>
                    [ ".h",          "\x{062D}" ],              # "\xD8\xAD" <.h>
                    [ "_h",          "\x{062E}" ],              # "\xD8\xAE" <_h>
                    [ "`",           "\x{0639}" ],              # "\xD8\xB9" <`>
                    [ ".g",          "\x{063A}" ],              # "\xD8\xBA" <.g>
                    [ "f",           "\x{0641}" ],              # "\xD9\x81" <f>
                    [ "q",           "\x{0642}" ],              # "\xD9\x82" <q>
                    [ "k",           "\x{0643}" ],              # "\xD9\x83" <k>
                    [ "m",           "\x{0645}" ],              # "\xD9\x85" <m>
                    [ "h",           "\x{0647}" ],              # "\xD9\x87" <h>
                    [ "w",           "\x{0648}" ],              # "\xD9\x88" <w>
                    [ "y",           "\x{064A}" ],              # "\xD9\x8A" <y>

                    [ "p",           "\x{067E}" ],
                    [ "v",           "\x{06A4}" ],
                    [ "g",           "\x{06AF}" ],

                    [ "c",           "\x{0681}" ],              # .ha with hamza
                    [ "^c",          "\x{0686}" ],              # gim with three
                    [ ",c",          "\x{0685}" ],              # _ha with three
                    [ "^z",          "\x{0698}" ],              # zay with three
                    [ "^n",          "\x{06AD}" ],              # kaf with three
                    [ "^l",          "\x{06B5}" ],              # lam with a bow above
                    [ ".r",          "\x{0695}" ],              # ra' with a bow below
                );


    my @scope = (
                    "'", "b", "t", "_t", "^g", ".h", "_h", "d", "_d", "r", "z", "s", "^s",
                    ".s", ".d", ".t", ".z", "`", ".g", "f", "q", "k", "l", "m", "n", "h",
                    "w", "T", "|", "B"  # "y" treated specifically in some cases
                );


    $decoder->[0] = Encode::Mapper->compile (

                [
                    'silent' => 0,
                ],

                    "_A",           [ "", "Y" ],
                    "_U",           [ "", "U" ],
                    "WA",           [ "", "W" ],

                # general non-protection of \TeX directives
                (
                    map {

                        "\\cap" . $_, [ "\\", "cap" . $_ ],

                    } 'A'..'Z', 'a'..'z', '_', '0'..'9'
                ),

                    "\\",           "\\",

                # strict \cap removal and white-space collapsing
                (
                    map {

                        "\\cap" . $_ . "\x09", [ '', "\\cap " ],
                        "\\cap" . $_ . "\x0A", [ '', "\\cap " ],
                        "\\cap" . $_ . "\x0D", [ '', "\\cap " ],
                        "\\cap" . $_ . "\x20", [ '', "\\cap " ],

                        "\\cap" . $_, "",

                    } "\x09", "\x0A", "\x0D", "\x20"
                ),

                    "\\cap",        "",

                # interfering rarely with the notation, or erroneous

                    "^A'a",         [ "^A'|", "a" ],

                    "^A",           [ "^A", "|" ],
                    "^I",           [ "^I", "|" ],
                    "^U",           [ "^U", "|" ],

                    "_a",           [ "_a", "|" ],
                    "_i",           [ "_i", "|" ],
                    "_u",           [ "_u", "|" ],

                    "_aA",          [ "_aA", "|" ],
                    "_aY",          [ "_aY", "|" ],
                    "_aU",          [ "_aU", "|" ],
                    "_aI",          [ "_aI", "|" ],

                    "'_a",          [ "", "_a" ],
                    "'_i",          [ "", "_i" ],
                    "'_u",          [ "", "_u" ],

                    "'^A",          [ "", "^A" ],
                    "'^I",          [ "", "^I" ],
                    "'^U",          [ "", "^U" ],

                # word-initial carriers

                    "'A",           [ "'A", "" ],
                    "'I",           [ "'i", "I" ],
                    "'U",           [ "'a", "U" ],
                    "'Y",           [ "'a", "Y" ],

                    "'_A",          [ "", "'Y" ],
                    "'_U",          [ "", "'U" ],

                    "'a",           [ "'a", "a" ],
                    "'i",           [ "'i", "i" ],
                    "'u",           [ "'a", "u" ],

                    "'",            "'a",

                # word-final carriers

                    "A'",           "A'|",
                    "I'",           "I'|",
                    "U'",           "U'|",

                    "a'",           "a'a",
                    "a'i",          "a'i",
                    "i'",           "i'y",
                    "u'",           "u'w",

                (
                    map {

                        $_ . "'", $_ . "'|",

                    } @scope
                ),

                # word-internal carriers

                    "a'A",          [ "a'A", "" ],

                    "I'aN",         [ "I'y", "aN" ],
                    "y'aN",         [ "y'y", "aN" ],

                    "A'A",          [ "A'|", "A" ],
                    "A'I",          [ "A'y", "I" ],
                    "A'U",          [ "A'w", "U" ],
                    "A'Y",          [ "A'|", "Y" ],

                    "A'_U",         [ "", "A'U" ],
                    "A'_A",         [ "", "A'Y" ],

                    "I'A",          [ "I'y", "A" ],
                    "I'I",          [ "I'y", "I" ],
                    "I'U",          [ "I'y", "U" ],
                    "I'Y",          [ "I'y", "Y" ],

                    "I'_U",         [ "", "I'U" ],
                    "I'_A",         [ "", "I'Y" ],

                    "y'A",          [ "y'y", "A" ],
                    "y'I",          [ "y'y", "I" ],
                    "y'U",          [ "y'y", "U" ],
                    "y'Y",          [ "y'y", "Y" ],

                    "y'_U",         [ "", "y'U" ],
                    "y'_A",         [ "", "y'Y" ],

                    "U'A",          [ "U'w", "A" ],
                    "U'I",          [ "U'y", "I" ],
                    "U'U",          [ "U'w", "U" ],
                    "U'Y",          [ "U'w", "Y" ],

                    "U'_U",         [ "", "U'U" ],
                    "U'_A",         [ "", "U'Y" ],

                    "uw'A",         [ "uw'w", "A" ],
                    "uw'I",         [ "uw'y", "I" ],
                    "uw'U",         [ "uw'w", "U" ],
                    "uw'Y",         [ "uw'w", "Y" ],

                    "uw'_U",        [ "", "uw'U" ],
                    "uw'_A",        [ "", "uw'Y" ],

                (
                    map {

                        "A'a" . $_, [ "A'|", "a" . $_ ],
                        "A'i" . $_, [ "A'y", "i" . $_ ],
                        "A'u" . $_, [ "A'w", "u" . $_ ],

                        "I'a" . $_, [ "I'y", "a" . $_ ],
                        "I'i" . $_, [ "I'y", "i" . $_ ],
                        "I'u" . $_, [ "I'y", "u" . $_ ],

                        "y'a" . $_, [ "y'y", "a" . $_ ],
                        "y'i" . $_, [ "y'y", "i" . $_ ],
                        "y'u" . $_, [ "y'y", "u" . $_ ],

                        "U'a" . $_, [ "U'w", "a" . $_ ],
                        "U'i" . $_, [ "U'y", "i" . $_ ],
                        "U'u" . $_, [ "U'w", "u" . $_ ],

                        "uw'a" . $_, [ "uw'w", "a" . $_ ],
                        "uw'i" . $_, [ "uw'y", "i" . $_ ],
                        "uw'u" . $_, [ "uw'w", "u" . $_ ],

                    } @scope, "y"
                ),

                (
                    map {

                        my $fix = $_;

                        $_ . "'A", [ $_ . "'A", "" ],
                        $_ . "'I", [ $_ . "'y", "I" ],
                        $_ . "'U", [ $_ . "'w", "U" ],
                        $_ . "'Y", [ $_ . "'a", "Y" ],

                        $_ . "'_U", [ "", $_ . "'U" ],
                        $_ . "'_A", [ "", $_ . "'Y" ],

                        map {

                            $fix . "'" . $_, [ $fix . "'|", $_ ],

                            $fix . "'a" . $_, [ $fix . "'a", "a" . $_ ],
                            $fix . "'i" . $_, [ $fix . "'y", "i" . $_ ],
                            $fix . "'u" . $_, [ $fix . "'w", "u" . $_ ],

                        } @scope, "y"

                    } @scope
                ),

            );


    $decoder->[1] = Encode::Mapper->compile (

                [
                    'others' => undef,
                    'silent' => 0,
                ],

                # non-exciting entities

                    "\x09",         "\x09",
                    "\x0A",         "\x0A",
                    "\x0D",         "\x0D",

                    " ",            " ",
                    ".",            ".",
                    ":",            ":",
                    "!",            "!",

                    "/",            "/",
                    "\\",           "\\",

                    ",",            "\x{060C}",                 # "\xD8\x8C" right-to-left-comma
                    ";",            "\x{061B}",                 # "\xD8\x9B" right-to-left-semicolon
                    "?",            "\x{061F}",                 # "\xD8\x9F" right-to-left-question-mark

                    "--",           "\x{0640}",                 # "\xD9\x80" ta.twiil
                    "\\shadda{}",   "\x{0651}",                 # "\xD9\x91" ^sadda
                    "\\sukuun{}",   "\x{0652}",                 # "\xD9\x92" sukuun

                (
                    map {

                        '' . $_, chr 0x0660 + $_,

                    } 0..9
                ),

                # non-voweled/sukuuned sunnies and moonies
                (
                    map {

                        my $x = 1 + $_;
                        my $y = "\x{0651}" x $_;                        # "\xD9\x91" ^sadda

                        map {

                            my $fix = $_;

                            $_->[0] x $x , $_->[1] . $y . "\x{0652}",   # "\xD9\x92" sukuun

                            $_->[0] x $x . "-a", $_->[1] . $y . "\x{064E}",
                            $_->[0] x $x . "-u", $_->[1] . $y . "\x{064F}",
                            $_->[0] x $x . "-i", $_->[1] . $y . "\x{0650}",

                            $_->[0] x $x . "-A", $_->[1] . $y . "\x{064E}\x{0627}",
                            $_->[0] x $x . "-Y", $_->[1] . $y . "\x{064E}\x{0649}",

                            $_->[0] x $x . "-U", $_->[1] . $y . "\x{064F}\x{0648}",
                            $_->[0] x $x . "-I", $_->[1] . $y . "\x{0650}\x{064A}",

                            $_->[0] x $x . "-aN", $_->[1] . $y . "\x{064B}\x{0627}",
                            $_->[0] x $x . "-uN", $_->[1] . $y . "\x{064C}",
                            $_->[0] x $x . "-iN", $_->[1] . $y . "\x{064D}",

                            $_->[0] x $x . "-aNA", $_->[1] . $y . "\x{064B}\x{0627}",
                            $_->[0] x $x . "-uNA", $_->[1] . $y . "\x{064C}\x{0627}",
                            $_->[0] x $x . "-iNA", $_->[1] . $y . "\x{064D}\x{0627}",

                            $_->[0] x $x . "-aNY", $_->[1] . $y . "\x{064B}\x{0649}",
                            $_->[0] x $x . "-uNY", $_->[1] . $y . "\x{064C}\x{0649}",
                            $_->[0] x $x . "-iNY", $_->[1] . $y . "\x{064D}\x{0649}",

                            $_->[0] x $x . "-aNU", $_->[1] . $y . "\x{064B}\x{0648}",
                            $_->[0] x $x . "-uNU", $_->[1] . $y . "\x{064C}\x{0648}",
                            $_->[0] x $x . "-iNU", $_->[1] . $y . "\x{064D}\x{0648}",

                        (
                            map {

                                $fix->[0] x $x . "-a" . $_->[0], [ $fix->[1] . $y . "\x{0652}", "a" . $_->[0] ],
                                $fix->[0] x $x . "-u" . $_->[0], [ $fix->[1] . $y . "\x{0652}", "u" . $_->[0] ],
                                $fix->[0] x $x . "-i" . $_->[0], [ $fix->[1] . $y . "\x{0652}", "i" . $_->[0] ],

                                $fix->[0] x $x . "-A" . $_->[0], [ $fix->[1] . $y . "\x{0652}", "A" . $_->[0] ],
                                $fix->[0] x $x . "-Y" . $_->[0], [ $fix->[1] . $y . "\x{0652}", "Y" . $_->[0] ],

                                $fix->[0] x $x . "-U" . $_->[0], [ $fix->[1] . $y . "\x{0652}", "U" . $_->[0] ],
                                $fix->[0] x $x . "-I" . $_->[0], [ $fix->[1] . $y . "\x{0652}", "I" . $_->[0] ],

                            } @sunny, @moony, @taaaa, $empty[0]
                        ),

                        } @sunny, @moony[1..$#moony]    # $moony[0] and $empty[0] excluded on purpose

                    } 0, 1
                ),

                $moony[0]->[0],     $moony[0]->[1],     # necessary of course ^^
                $empty[0]->[0],     $empty[0]->[1],     # if --others is defined

                # voweled/non-sukuuned sunnies and moonies
                (
                    map {

                        my $x = 1 + $_;
                        my $y = "\x{0651}" x $_;                        # "\xD9\x91" ^sadda

                        map {

                            my $fix = $_;

                            $_->[0] x $x . "a", $_->[1] . $y . "\x{064E}",
                            $_->[0] x $x . "u", $_->[1] . $y . "\x{064F}",
                            $_->[0] x $x . "i", $_->[1] . $y . "\x{0650}",

                            $_->[0] x $x . "_a", $_->[1] . $y . "\x{0670}",
                            $_->[0] x $x . "_u", $_->[1] . $y . "\x{0657}",
                            $_->[0] x $x . "_i", $_->[1] . $y . "\x{0656}",

                            $_->[0] x $x . "_aA", $_->[1] . $y . "\x{0670}\x{0627}",
                            $_->[0] x $x . "_aY", $_->[1] . $y . "\x{0670}\x{0649}",
                            $_->[0] x $x . "_aU", $_->[1] . $y . "\x{0670}\x{0648}",
                            $_->[0] x $x . "_aI", $_->[1] . $y . "\x{0670}\x{064A}",

                            $_->[0] x $x . "A", $_->[1] . $y . "\x{064E}\x{0627}",
                            $_->[0] x $x . "Y", $_->[1] . $y . "\x{064E}\x{0649}",

                            $_->[0] x $x . "U", $_->[1] . $y . "\x{064F}\x{0648}",
                            $_->[0] x $x . "I", $_->[1] . $y . "\x{0650}\x{064A}",

                            $_->[0] x $x . "Uw", [ $_->[1] . $y . "\x{064F}", "ww" ],
                            $_->[0] x $x . "Iy", [ $_->[1] . $y . "\x{0650}", "yy" ],

                            $_->[0] x $x . "^A", $_->[1] . $y . "\x{064F}\x{0627}\x{0653}",
                            $_->[0] x $x . "^U", $_->[1] . $y . "\x{064F}\x{0648}\x{0653}",
                            $_->[0] x $x . "^I", $_->[1] . $y . "\x{0650}\x{064A}\x{0653}",

                            $_->[0] x $x . "^Uw", [ $_->[1] . $y . "\x{064F}\x{0648}\x{0655}", "|" ],  # roughly
                            $_->[0] x $x . "^Iy", [ $_->[1] . $y . "\x{0650}\x{0649}\x{0655}", "|" ],  # roughly

                            $_->[0] x $x . "aa", [ '', $_->[0] x $x . "A" ],
                            $_->[0] x $x . "uw", [ '', $_->[0] x $x . "U" ],
                            $_->[0] x $x . "iy", [ '', $_->[0] x $x . "I" ],

                        (
                            map {

                                $fix->[0] x $x . "uw" . $_, [ $fix->[1] . $y . "\x{064F}", "w" . $_ ],
                                $fix->[0] x $x . "iy" . $_, [ $fix->[1] . $y . "\x{0650}", "y" . $_ ],

                            } qw "a u i A Y U I _a _u _i ^A ^U ^I"  # includes "aa uw iy _aA _aY _aU _aI"
                        ),

                            $_->[0] x $x . "_aA'|aN", $_->[1] . $y . "\x{0670}\x{0627}\x{0621}\x{064B}",
                            $_->[0] x $x . "A'|aN", $_->[1] . $y . "\x{064E}\x{0627}\x{0621}\x{064B}",

                            $_->[0] x $x . "aN", $_->[1] . $y . "\x{064B}\x{0627}",
                            $_->[0] x $x . "uN", $_->[1] . $y . "\x{064C}",
                            $_->[0] x $x . "iN", $_->[1] . $y . "\x{064D}",

                        } @sunny, @moony, $empty[0]

                    } 0, 1
                ),

                # 'alif protected endings
                (
                    map {

                        my $x = 1 + $_;
                        my $y = "\x{0651}" x $_;                        # "\xD9\x91" ^sadda

                        map {

                            $_->[0] x $x . "_aA'|aNA", $_->[1] . $y . "\x{0670}\x{0627}\x{0621}\x{064B}\x{0627}",
                            $_->[0] x $x . "A'|aNA", $_->[1] . $y . "\x{064E}\x{0627}\x{0621}\x{064B}\x{0627}",

                            $_->[0] x $x . "aNA", $_->[1] . $y . "\x{064B}\x{0627}",
                            $_->[0] x $x . "uNA", $_->[1] . $y . "\x{064C}\x{0627}",
                            $_->[0] x $x . "iNA", $_->[1] . $y . "\x{064D}\x{0627}",

                            $_->[0] x $x . "aNY", $_->[1] . $y . "\x{064B}\x{0649}",
                            $_->[0] x $x . "uNY", $_->[1] . $y . "\x{064C}\x{0649}",
                            $_->[0] x $x . "iNY", $_->[1] . $y . "\x{064D}\x{0649}",

                            $_->[0] x $x . "aNU", $_->[1] . $y . "\x{064B}\x{0648}",
                            $_->[0] x $x . "uNU", $_->[1] . $y . "\x{064C}\x{0648}",
                            $_->[0] x $x . "iNU", $_->[1] . $y . "\x{064D}\x{0648}",

                            $_->[0] x $x . "aW", $_->[1] . $y . "\x{064E}\x{0648}\x{0652}\x{0627}",
                            $_->[0] x $x . "UA", $_->[1] . $y . "\x{064F}\x{0648}\x{0627}",

                        } @sunny, @moony, $empty[0]

                    } 0, 1
                ),

                # taa' marbuu.ta endings
                (
                    map {

                        $_->[0] . "a", $_->[1] . "\x{064E}",
                        $_->[0] . "u", $_->[1] . "\x{064F}",
                        $_->[0] . "i", $_->[1] . "\x{0650}",

                        $_->[0] . "aN", $_->[1] . "\x{064B}",
                        $_->[0] . "uN", $_->[1] . "\x{064C}",
                        $_->[0] . "iN", $_->[1] . "\x{064D}",

                    } @taaaa
                ),

                # definite article assimilation .. non-linguistic
                (
                    map {

                        $_->[0] . "-" . $_->[0], [ "\x{0644}", $_->[0] x 2 ],   # goodness ^^

                        "l-" . $_->[0] x 2, [ '', $_->[0] . "-" . $_->[0] ],    # equivalent

                    } @sunny, @moony
                ),

                # initial vowels
                (
                    map {

                        my $fix = $_;

                        $_->[0] . "a", $_->[1] . "\x{064E}",
                        $_->[0] . "u", $_->[1] . "\x{064F}",
                        $_->[0] . "i", $_->[1] . "\x{0650}",

                        $_->[0] . "_a", $_->[1] . "\x{0670}",
                        $_->[0] . "_u", $_->[1] . "\x{0657}",
                        $_->[0] . "_i", $_->[1] . "\x{0656}",

                        $_->[0] . "_aA", $_->[1] . "\x{0670}\x{0627}",
                        $_->[0] . "_aY", $_->[1] . "\x{0670}\x{0649}",
                        $_->[0] . "_aU", $_->[1] . "\x{0670}\x{0648}",
                        $_->[0] . "_aI", $_->[1] . "\x{0670}\x{064A}",

                        $_->[0] . "A", $_->[1] . "\x{064E}\x{0627}",
                        $_->[0] . "Y", $_->[1] . "\x{064E}\x{0649}",

                        $_->[0] . "U", $_->[1] . "\x{064F}\x{0648}",
                        $_->[0] . "I", $_->[1] . "\x{0650}\x{064A}",

                        $_->[0] . "Uw", [ $_->[1] . "\x{064F}\x{0648}\x{0651}", "|" ],
                        $_->[0] . "Iy", [ $_->[1] . "\x{0650}\x{064A}\x{0651}", "|" ],

                        $_->[0] . "^A", "\x{0622}",                 # use no equivs
                        $_->[0] . "^U", "\x{0623}\x{064F}\x{0648}", # use no equivs
                        $_->[0] . "^I", "\x{0625}\x{0650}\x{064A}", # use no equivs

                        $_->[0] . "aa", [ '', $_->[0] . "A" ],
                        $_->[0] . "uw", [ '', $_->[0] . "U" ],
                        $_->[0] . "iy", [ '', $_->[0] . "I" ],

                        (
                            map {

                                $fix->[0] . "uw" . $_, [ $fix->[1] . "\x{064F}", "w" . $_ ],
                                $fix->[0] . "iy" . $_, [ $fix->[1] . "\x{0650}", "y" . $_ ],

                            } qw "a u i A Y U I _a _u _i ^A ^U ^I"  # includes "aa uw iy _aA _aY _aU _aI"
                        ),

                        $_->[0] . "_aA'|aN", $_->[1] . "\x{0670}\x{0627}\x{0621}\x{064B}",
                        $_->[0] . "A'|aN", $_->[1] . "\x{064E}\x{0627}\x{0621}\x{064B}",

                        $_->[0] . "aN", $_->[1] . "\x{064B}\x{0627}",
                        $_->[0] . "uN", $_->[1] . "\x{064C}",
                        $_->[0] . "iN", $_->[1] . "\x{064D}",

                    } $empty[1]
                ),

                # non-notation insertion escapes provided through ':xml'

            );


    $decoder->[2] = Encode::Mapper->compile (

                [
                    'silent' => 0,
                ],

                # modern internal substitution with wa.sla
                (
                    map {

                        my $vowel = $_;

                        map {

                            $vowel . "\x{0627}" . $_, [ $vowel, "\x{0671}" ],

                        } "\x{064E}", "\x{064F}", "\x{0650}"

                    } "\x{064E}", "\x{064F}", "\x{0650}"
                ),

                # modern external substitution with wa.sla
                (
                    map {

                        my $vowel = $_;

                        map {

                            "\x{064E}" . $_ . "\x{0627}" . $vowel, [ "\x{064E}" . $_, "\x{0671}" ],
                            "\x{064F}" . $_ . "\x{0627}" . $vowel, [ "\x{064F}" . $_, "\x{0671}" ],
                            "\x{0650}" . $_ . "\x{0627}" . $vowel, [ "\x{0650}" . $_, "\x{0671}" ],

                            "\x{064E}\x{0627}" . $_ . "\x{0627}" . $vowel, [ "\x{064E}\x{0627}" . $_, "\x{0671}" ],
                            "\x{064E}\x{0649}" . $_ . "\x{0627}" . $vowel, [ "\x{064E}\x{0649}" . $_, "\x{0671}" ],
                            "\x{064F}\x{0648}" . $_ . "\x{0627}" . $vowel, [ "\x{064F}\x{0648}" . $_, "\x{0671}" ],
                            "\x{0650}\x{064A}" . $_ . "\x{0627}" . $vowel, [ "\x{0650}\x{064A}" . $_, "\x{0671}" ],

                        } "\x09", "\x0A", "\x0D", "\x20", "\x0D\x0A", "\x20\x20", "\x20\x20\x20", "\x20\x20\x20\x20"

                    } "\x{064E}", "\x{064F}", "\x{0650}"
                ),

                # laam + 'alif .. either enforce ligatures, or shuffle the diacritics
                (
                    map {

                        my $alif = $_;

                        map {

                            my $vowel = $_;

                            map {

                                "\x{0644}" . $_ . $vowel . $alif,
                                "\x{0644}" . $alif . $_ . $vowel,

                            } "", "\x{0651}"

                        } "\x{064E}", "\x{064F}", "\x{0650}",
                          "\x{064B}", "\x{064C}", "\x{064D}",
                          "\x{0652}"

                    } "\x{0622}", "\x{0623}", "\x{0625}", "\x{0627}", "\x{0671}"
                ),

                # optional ligatures to enforce here

            );


    no strict 'refs';

    return ${ $cls . '::decoder' } = $decoder;
}


sub eecoder ($@) {
    my $cls = shift @_;
    my $ext = shift @_;

    my %opt = @_ ? do { my $i = 0; map { ++$i % 2 ? lc $_ : $_ } @_ } : ();

    no strict 'refs';

    my $refcoder = \${ $cls . '::' . $ext };

    use strict 'refs';


    if (exists $opt{'load'}) {

        if (ref \$opt{'load'} eq 'SCALAR') {

            if (my $done = do $opt{'load'}) {   # file-define

                return ${$refcoder} = $done;
            }
            else {

                carp "Cannot parse " . $opt{'load'} . ": $@" if $@;
                carp "Cannot do " . $opt{'load'} . ": $!" unless defined $done;
                carp "Cannot run " . $opt{'load'};

                return undef;
            }
        }
        elsif (UNIVERSAL::isa($opt{'load'}, 'CODE')) {

            return ${$refcoder} = $opt{'load'}->();
        }
        elsif (UNIVERSAL::isa($opt{'load'}, 'ARRAY')) {

            if (grep { not $_->isa('Encode::Mapper') } @{$opt{'load'}}) {
                carp "Expecting a reference to an array of 'Encode::Mapper' objects";
                return undef;
            }

            return ${$refcoder} = $opt{'load'};
        }

        carp "Invalid type of the 'load' parameter, action ignored";
        return undef;
    }

    if (exists $opt{'dump'}) {

        require Data::Dumper;

        my ($data, $i, @refs, @data);

        $data = Data::Dumper->new([${$refcoder}], [$ext]);

        for ($i = 0; $i < @{${$refcoder}}; $i++) {

            $refs[$i] = ['L', 'H', $ext . "->[$i]" ];
            $data[$i] = ${$refcoder}->[$i]->dumper($refs[$i]);
        }

        if (ref \$opt{'dump'} eq 'SCALAR') {

            if ($opt{'dump'} =~ /^[A-Z][A-Za-z]*(\:\:[A-Z][A-Za-z]*)+$/) {

                my $class = $cls;

                for ($class, $opt{'dump'}) {

                    $_ =~ s/\:\:/\//g;
                    $_ .= '.pm';
                }

                my $where = $INC{$class} =~ /^(.*)$class$/;

                $opt{'dump'} = $where . $opt{'dump'};
            }
            elsif ($opt{'dump'} !~ s/^!// and -f $opt{'dump'}) {    # 'SCALAR'

                carp "The file " . $opt{'dump'} . " exists, ignoring action";
                return undef;
            }

            open my $file, '>', $opt{'dump'} or die $opt{'dump'};
            print $file 'my ($L, $H, $' . $ext . ');';

            for ($i = 0; $i < @{${$refcoder}}; $i++) {

                print $file $data[$i]->Useqq(1)->Indent(0)->Dump();
            }

            print $file 'return $' . $ext . ';';
            close $file;

            return ${$refcoder};
        }
        elsif (UNIVERSAL::isa($opt{'dump'}, 'SCALAR')) {

            my $dump = ${$opt{'dump'}};

            ${$opt{'dump'}} = $data;

            return ${$refcoder};
        }
    }

    return -1;
}


1;

__END__


=head1 NAME

Encode::Arabic::ArabTeX - Perl extension for multi-purpose processing of the ArabTeX notation of Arabic

=head1 REVISION

    $Revision: 1.18 $             $Date: 2003/09/08 14:43:14 $


=head1 SYNOPSIS

    use Encode::Arabic::ArabTeX;        # imports just like 'use Encode' would, plus extended options

    while ($line = <>) {                # maps the ArabTeX notation for Arabic into the Arabic script

        print encode 'utf8', decode 'arabtex', $line;       # 'arabtex' alias 'ArabTeX'
    }

    # ArabTeX lower ASCII transliteration <--> Arabic script in Perl's internal format

    $string = decode 'ArabTeX', $octets;
    $octets = encode 'ArabTeX', $string;

    Encode::Arabic::ArabTeX->encoder('dump' => '!./encoder.code');  # dump the encoder engine to file
    Encode::Arabic::ArabTeX->decoder('load');   # load the decoder engine from module's extra sources


=head1 DESCRIPTION

ArabTeX is an excellent extension to TeX/LaTeX designed for typesetting the right-to-left scripts of
the Orient. It comes up with very intuitive and comprehensible lower ASCII transliterations, the
expressive power of which is even better than that of the scripts.

L<Encode::Arabic::ArabTeX|Encode::Arabic::ArabTeX> implements the rules needed for proper interpretation
of the ArabTeX notation of Arabic. The conversion ifself is done by L<Encode::Mapper|Encode::Mapper>, and
the user interface is built on the L<Encode::Encoding|Encode::Encoding> module.


=head2 ENCODING BUSINESS

Since the ArabTeX notation is not a simple mapping to the graphemes of the Arabic script, encoding the script
into the notation is ambiguous. Two different strings in the notation may correspond to identical strings in
the script. Heuristics must be engaged to decide which of the representations is more appropriate.

Together with this bottle-neck, encoding may not be perfectly invertible by the decode operation, due to
over-generation or approximations in the encoding algorithm.

There are situations where conversion from the Arabic script to the ArabTeX notation is still convenient and
useful. Imagine you need to edit the data, enhance it with vowels or other diacritical marks, produce phonetic
transcripts and trim the typography of the script ... Do it in the ArabTeX notation, having an unrivalled
control over your acts!

Nonetheless, encoding is not the very purpose for this module's existence ;)


=head2 DECODING BUSINESS

The module decodes the ArabTeX notation as defined in the User Manual Version 3.09 of July 22, 1999,
L<ftp://ftp.informatik.uni-stuttgart.de/pub/arabtex/doc/arabdoc.pdf>. The implementation uses three levels
of L<Encode::Mapper|Encode::Mapper> engines to decode the notation:

=over

=item I<Hamza> writing

I<Hamza> carriers are determined from the context in accordance with the Arabic orthographical conventions.
The first level of mapping expands every C<< <'> >> into the verbatim encoding of the relevant carrier.
This level of processing can become optional, if people ever need to encode the I<hamza> carriers explicitly.

=item Grapheme generation

The core level includes most of the rules needed, and converts the ArabTeX notation to Arabic graphemes in
Unicode. The engine recognizes all the consonants of Modern Standard Arabic, plus the following letters:

                    [ "|",           ""         ],              # ArabTeX's "invisible consonant"
                    [ "T",           "\x{0629}" ],              # ta' marbu.ta

                    [ "p",           "\x{067E}" ],              # pa'
                    [ "v",           "\x{06A4}" ],              # va'
                    [ "g",           "\x{06AF}" ],              # gaf

                    [ "c",           "\x{0681}" ],              # .ha with hamza
                    [ "^c",          "\x{0686}" ],              # gim with three
                    [ ",c",          "\x{0685}" ],              # _ha with three
                    [ "^z",          "\x{0698}" ],              # zay with three
                    [ "^n",          "\x{06AD}" ],              # kaf with three
                    [ "^l",          "\x{06B5}" ],              # lam with a bow above
                    [ ".r",          "\x{0695}" ],              # ra' with a bow below

There are many nice features in the notation, like assimilation, gemmination, hyphenation, all implemented here.
Defective and historical writings of vowels are supported, too! Try yourself if your fonts can handle these ;)

=item I<Wasla>, ligatures

I<Wasla> is introduced if there is a preceding long or short vowel, and the blank space is one newline, one
tabulator, or up to four single spaces. Optionally, diacritical marks in between I<laam> and I<'alif> go after
the latter letter, since most of the current systems rendering the Arabic script do not produce the desired
ligatures if the two kinds of graphemes are not adjacent immediately.

=back

There are modes and options in ArabTeX that have not been dealt with yet in
L<Encode::Arabic::ArabTeX|Encode::Arabic::ArabTeX>, still, mutual consistency of the systems is very high. This
release does not support vowel quoting and works in the ArabTeX's C<\fullvocalize> mode only. The inconvenience
will be made up for in the forthcoming versions. Regular expression substitution will be helpful to the user by
then.


=head2 EXPORT AND ENGINES

The module exports as if C<use Encode> also appeared in the package. The C<import> options, except for the
first-place C<:xml>, are just delegated to L<Encode|Encode> and imports performed properly.

If the first element in the list to C<use> is C<:xml>, all XML markup, or rather any data enclosed in the
well-paired and non-nested angle brackets C<< < >> and C<< > >>, will be preserved. Properties of the
L<Encode::Arabic::ArabTeX|Encode::Arabic::ArabTeX> engines can be generally controlled through the
L<Encode::Mapper|Encode::Mapper> API.

Initialization of the engines takes place the first time they are used, unless they have already been defined.
There are two explicit methods for it:

=over

=item encoder

Initialize or redefine the encoder engine. If no parameters are given, rules in the module are compiled into a
list of L<Encode::Mapper|Encode::Mapper> objects. Currently, the C<--dump> and C<--load> options have some
experimental meaning.

=item decoder

See the description of C<encoder>.

=back

These methods will be refined in the future, becoming the interface for miscelaneous settings etc.


=head1 SEE ALSO

L<Encode::Arabic|Encode::Arabic>, L<Encode::Mapper|Encode::Mapper>,
L<Encode::Encoding|Encode::Encoding>, L<Encode|Encode>

ArabTeX system      L<ftp://ftp.informatik.uni-stuttgart.de/pub/arabtex/arabtex.htm>

Klaus Lagally       L<http://www.informatik.uni-stuttgart.de/ifi/bs/people/lagall_e.htm>

External Tools Not Only for ArabTeX Documents
    L<http://ufal.mff.cuni.cz/publications/year2002/FLM2002.zip>

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
