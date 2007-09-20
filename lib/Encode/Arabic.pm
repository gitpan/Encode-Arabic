# ###################################################################### Otakar Smrz, 2003/01/23
#
# Encodings of Arabic ##########################################################################

# $Id: Arabic.pm 338 2007-06-07 01:30:40Z smrz $

package Encode::Arabic;

our $VERSION = '1.5' || do { q $Revision: 338 $ =~ /(\d+)/; sprintf "%4.2f", $1 / 100 };


sub import {            # perform import as if Encode were used one level before this module

    if (defined $_[1] and $_[1] eq ':modes') {

        require Exporter;

        @ISA = qw 'Exporter';
        @EXPORT_OK = qw 'enmode demode';

        __PACKAGE__->export_to_level(1, $_[0], 'enmode', 'demode');

        splice @_, 1, 1;
    }

    require Encode;

    Encode->export_to_level(1, @_);
}


use lib '..';

use Encode::Arabic::ArabTeX;
use Encode::Arabic::ArabTeX::RE;

use Encode::Arabic::ArabTeX::Verbatim;

use Encode::Arabic::ArabTeX::ZDMG;
use Encode::Arabic::ArabTeX::ZDMG::RE;

use Encode::Arabic::Buckwalter;

use Encode::Arabic::Parkinson;


sub enmode ($@) {

    my $enc = shift;
    my $obj = Encode::find_encoding($enc);

    unless (defined $obj){

        require Carp;
        Carp::croak("Unknown encoding '$enc'");
    }

    $obj->enmode(@_);
}


sub demode ($@) {

    my $enc = shift;
    my $obj = Encode::find_encoding($enc);

    unless (defined $obj){

        require Carp;
        Carp::croak("Unknown encoding '$enc'");
    }

    $obj->demode(@_);
}


1;

__END__


=head1 NAME

Encode::Arabic - Encodings of Arabic


=head1 REVISION

    $Revision: 338 $        $Date: 2007-06-07 03:30:40 +0200 (Thu, 07 Jun 2007) $


=head1 SYNOPSIS

    use Encode::Arabic;                 # imports just like 'use Encode' even with options would

    while ($line = <>) {                # renders the ArabTeX notation for Arabic both in the ..

        print encode 'utf8', decode 'arabtex', $line;          # .. Arabic script proper and the
        print encode 'utf8', decode 'arabtex-zdmg', $line;     # .. Latin phonetic transcription
    }

    # 'use Encode::Arabic ":modes"' would export the functions controlling the conversion modes

    Encode::Arabic::demode 'arabtex', 'default';
    Encode::Arabic::enmode 'buckwalter', 'full', 'xml', 'strip off kashida';

    # Arabic in lower ASCII transliterations <--> Arabic script in Perl's internal encoding

    $string = decode 'ArabTeX', $octets;
    $octets = encode 'Buckwalter', $string;

    $string = decode 'Buckwalter', $octets;
    $octets = encode 'ArabTeX', $string;

    # Arabic in lower ASCII transliterations <--> Latin phonetic transcription, Perl's utf8

    $string = decode 'Buckwalter', $octets;
    $octets = encode 'ArabTeX', $string;

    $string = decode 'ArabTeX-ZDMG', $octets;
    $octets = encode 'utf8', $string;


=head1 DESCRIPTION

This module is a wrapper for various implementations of the encoding systems used for the Arabic
language and covering even some non-Arabic extensions to the Arabic script. The included modules
fit in the philosophy of L<Encode::Encoding|Encode::Encoding> and can be used directly with the
L<Encode|Encode> module.


=head2 LIST OF ENCODINGS

=over

=item ArabTeX

ArabTeX multi-character notation for Arabic / Perl's internal format for the Arabic script

L<Encode::Arabic::ArabTeX|Encode::Arabic::ArabTeX>,
uses L<Encode::Mapper|Encode::Mapper>

=item ArabTeX-RE

Deprecated method using sequential regular-expression substitutions. Limited in scope over the
ArabTeX notation and non-efficient in data processing, still, not requiring the
L<Encode::Mapper|Encode::Mapper> module.

L<Encode::Arabic::ArabTeX::RE|Encode::Arabic::ArabTeX::RE>

=item ArabTeX-Verbatim

ArabTeX multi-character I<verbatim> notation for Arabic / Perl's internal format for the Arabic script

L<Encode::Arabic::ArabTeX::Verbatim|Encode::Arabic::ArabTeX::Verbatim>,
uses L<Encode::Mapper|Encode::Mapper>

=item ArabTeX-ZDMG

ArabTeX multi-character notation for Arabic / Perl's internal format for the Latin phonetic
trascription in the ZDMG style

L<Encode::Arabic::ArabTeX::ZDMG|Encode::Arabic::ArabTeX::ZDMG>,
uses L<Encode::Mapper|Encode::Mapper>

=item ArabTeX-ZDMG-RE

Deprecated method using sequential regular-expression substitutions. Limited in scope over the
ArabTeX notation and non-efficient in data processing, still, not requiring the
L<Encode::Mapper|Encode::Mapper> module.

L<Encode::Arabic::ArabTeX::ZDMG::RE|Encode::Arabic::ArabTeX::ZDMG::RE>

=item Buckwalter

Buckwalter one-to-one notation for Arabic / Perl's internal format for the Arabic script

L<Encode::Arabic::Buckwalter|Encode::Arabic::Buckwalter>

=item Parkinson

Parkinson one-to-one notation for Arabic / Perl's internal format for the Arabic script

L<Encode::Arabic::Parkinson|Encode::Arabic::Parkinson>

=back

There are generic aliases to these provided by L<Encode|Encode>. Case does not matter and all
characters of the class C<[ _-]> are interchangable.

Note that the standard L<Encode|Encode> module already deals with several other single-byte encoding
schemes for Arabic popular with whichever operating system, be it *n*x, Windows, DOS or Macintosh.
See L<Encode::Supported|Encode::Supported> and L<Encode::Byte|Encode::Byte> for their identification
names and aliases.


=head2 EXPORTS & MODES

The module exports as if C<use Encode> also appeared in the calling package. The C<import> options are
just delegated to L<Encode|Encode> and imports performed properly, with the exception of the
C<:modes> option coming first in the list. In such a case, the following functions will be introduced
into the namespace of the importing package:

=over

=item enmode ($enc, @list)

Calls the C<enmode> method associated with the given C<$enc> encoding, and passes the C<@list> to it.
The idea is similar to the C<encode> functions and methods of the L<Encode|Encode> and
L<Encode::Encoding|Encode::Encoding> modules, respectively. Used for control over the modes of conversion.

=item demode ($enc, @list)

Analogous to C<enmode>, but calling the appropriate C<demode> method. See the individual implementations
of the listed encodings.

=back


=head1 SEE ALSO

Encode::Arabic Online Interface L<http://ufal.mff.cuni.cz/~smrz/Encode/Arabic/>

Encode Arabic Project           L<http://sourceforge.net/projects/encode-arabic/>

ElixirFM Project                L<http://sourceforge.net/projects/elixir-fm/>

Klaus Lagally's ArabTeX         L<ftp://ftp.informatik.uni-stuttgart.de/pub/arabtex/arabtex.htm>

Tim Buckwalter's Qamus          L<http://www.qamus.org/>

Arabeyes Arabic Unix Project    L<http://www.arabeyes.org/>

Lecture Notes on Arabic NLP     L<http://ufal.mff.cuni.cz/~smrz/ANLP/anlp-lecture-notes.pdf>

L<Encode|Encode>,
L<Encode::Encoding|Encode::Encoding>,
L<Encode::Mapper|Encode::Mapper>,
L<Encode::Byte|Encode::Byte>

L<Locale::Recode|Locale::Recode>

L<MARC::Charset|MARC::Charset>

L<Lingua::AR::MacArabic|Lingua::AR::MacArabic>,
L<Lingua::AR::Word|Lingua::AR::Word>

L<Text::TransMetaphone|Text::TransMetaphone>


=head1 AUTHOR

Otakar Smrz, L<http://ufal.mff.cuni.cz/~smrz/>

    eval { 'E<lt>' . ( join '.', qw 'otakar smrz' ) . "\x40" . ( join '.', qw 'mff cuni cz' ) . 'E<gt>' }

Perl is also designed to make the easy jobs not that easy ;)


=head1 COPYRIGHT AND LICENSE

Copyright 2003-2007 by Otakar Smrz

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut
