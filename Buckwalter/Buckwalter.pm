# ###################################################################### Otakar Smrz, 2003/01/23
#
# Encoding of Arabic: Tim Buckwalter's Notation ##################################### 2003/06/19

# $Id: Buckwalter.pm,v 1.7 2003/09/01 11:55:41 smrz Exp $

package Encode::Arabic::Buckwalter;

use 5.008;

use strict;
use warnings;

our $VERSION = do { my @r = q$Revision: 1.7 $ =~ /\d+/g; sprintf "%d." . "%02d" x $#r, @r };


use Encode::Encoding;
use base 'Encode::Encoding';

__PACKAGE__->Define('buckwalter', 'Buckwalter');


# use subs 'encoder', 'decoder';    # ignores later prototypes

sub encoder ($);    # respect prototypes
sub decoder ($);    # respect prototypes


sub import {            # perform import as if Encode were used one level before this module

    undef &encoder;
    undef &decoder;

    if (defined $_[1] and $_[1] eq ':xml') {    # interfere little with possible Encode's options

        eval q {

            sub encoder ($) {
                $_[0] =~ tr[\x{060C}\x{061B}\x{061F}\x{0621}-\x{063A}\x{0640}-\x{0652}\x{0670}\x{0671}\x{067E}\x{0686}\x{06A4}\x{06AF}]
                           [,;?'|OWI}AbptvjHxd*rzs$SDTZEg_fqklmnhwYyFNKaui~o`{PJVG];

                return $_[0];
            }

            sub decoder ($) {
                $_[0] =~ tr[,;?'|OWI}AbptvjHxd*rzs$SDTZEg_fqklmnhwYyFNKaui~o`{PJVG]
                           [\x{060C}\x{061B}\x{061F}\x{0621}-\x{063A}\x{0640}-\x{0652}\x{0670}\x{0671}\x{067E}\x{0686}\x{06A4}\x{06AF}];

                return $_[0];
            }
        };

        splice @_, 1, 1;
    }
    else {

        eval q {

            sub encoder ($) {
                $_[0] =~ tr[\x{060C}\x{061B}\x{061F}\x{0621}-\x{063A}\x{0640}-\x{0652}\x{0670}\x{0671}\x{067E}\x{0686}\x{06A4}\x{06AF}]
                           [,;?'|>&<}AbptvjHxd*rzs$SDTZEg_fqklmnhwYyFNKaui~o`{PJVG];

                return $_[0];
            }

            sub decoder ($) {
                $_[0] =~ tr[,;?'|>&<}AbptvjHxd*rzs$SDTZEg_fqklmnhwYyFNKaui~o`{PJVG]
                           [\x{060C}\x{061B}\x{061F}\x{0621}-\x{063A}\x{0640}-\x{0652}\x{0670}\x{0671}\x{067E}\x{0686}\x{06A4}\x{06AF}];

                return $_[0];
            }
        };
    }

    require Encode;

    Encode->export_to_level(1, @_);
}


sub encode ($$;$) {
    my (undef, $text, $check) = @_;

    $_[1] = '' if $check;                   # needed by in-place edit

    return encoder $text;
}


sub decode ($$;$) {
    my (undef, $text, $check) = @_;

    $_[1] = '' if $check;                   # needed by in-place edit

    return decoder $text;
}


1;

__END__


=head1 NAME

Encode::Arabic::Buckwalter - Perl extension for Tim Buckwalter's transliteration of Arabic

=head1 REVISION

    $Revision: 1.7 $        $Date: 2003/09/01 11:55:41 $


=head1 SYNOPSIS

    use Encode::Arabic::Buckwalter;         # imports just like 'use Encode' would, plus more

    while ($line = <>) {                    # Tim Buckwalter's mapping into the Arabic script

        print encode 'utf8', decode 'buckwalter', $line;    # 'buckwalter' alias 'Buckwalter'
    }

    # shell filter of data, e.g. in *n*x systems instead of viewing the Arabic script proper

    % perl -MEncode::Arabic::Buckwalter -pe 'encode "buckwalter", decode "utf8", $_'


=head1 DESCRIPTION

Tim Buckwalter's notation is a one-to-one transliteration of the Arabic script for Modern Standard
Arabic, using lower ASCII characters to encode the graphemes of the original script. This system
has been very popular in Natural Language Processing, however, there are limits to its applicability
due to numerous non-alphabetic codes involved.


=head2 IMPLEMENTATION

The module takes care of the L<Encode::Encoding|Encode::Encoding> programming interface, while the
effective code is Tim Buckwalter's C<tr>ick:

    $encode =~ tr[\x{060C}\x{061B}\x{061F}\x{0621}-\x{063A}\x{0640}-\x{0652}    # !! no break in true perl !!
                  \x{0670}\x{0671}\x{067E}\x{0686}\x{06A4}\x{06AF}]
                 [,;?'|>&<}AbptvjHxd*rzs$SDTZEg_fqklmnhwYyFNKaui~o`{PJVG];

    $decode =~ tr[,;?'|>&<}AbptvjHxd*rzs$SDTZEg_fqklmnhwYyFNKaui~o`{PJVG]
                 [\x{060C}\x{061B}\x{061F}\x{0621}-\x{063A}\x{0640}-\x{0652}    # !! no break in true perl !!
                  \x{0670}\x{0671}\x{067E}\x{0686}\x{06A4}\x{06AF}];


=head2 EXPORT POLICY

If the first element in the list to C<use> is C<:xml>, the alternative mapping is introduced that suits
the XML etiquette. This option is there only to replace the C<< >&< >> reserved characters by C<OWI>
while still having a one-to-one notation. There is no XML parsing involved, and the markup would get
distorted if subject to C<decode>!

    $using_xml = eval q { use Encode::Arabic::Buckwalter ':xml'; decode 'buckwalter', 'OWI' };
    $classical = eval q { use Encode::Arabic::Buckwalter;        decode 'buckwalter', '>&<' };

    # $classical eq $using_xml and $classical eq "\x{0623}\x{0624}\x{0625}"

The module exports as if C<use Encode> also appeared in the package. The other C<import> options are
just delegated to L<Encode|Encode> and imports performed properly.


=head1 SEE ALSO

L<Encode::Arabic|Encode::Arabic>, L<Encode|Encode>, L<Encode::Encoding|Encode::Encoding>

Tim Buckwalter's Qamus  L<http://www.qamus.org>

Buckwalter Arabic Morphological Analyzer
    L<http://www.ldc.upenn.edu/Catalog/CatalogEntry.jsp?catalogId=LDC2002L49>

Xerox Arabic Home Page  L<http://www.arabic-morphology.com>

Arabeyes Duali Project  L<http://www.arabeyes.org/project.php?proj=Duali>


=head1 AUTHOR

Otakar Smrz, L<http://ckl.mff.cuni.cz/smrz/>

    eval { 'E<lt>' . 'smrz' . "\x40" . ( join '.', qw 'ckl mff cuni cz' ) . 'E<gt>' }

Perl is also designed to make the easy jobs not that easy ;)


=head1 COPYRIGHT AND LICENSE

Copyright 2003 by Otakar Smrz

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut
