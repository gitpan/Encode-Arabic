# ################################################################### Otakar Smrz, 2003/01/23
#
# Encoding of Arabic: ArabTeX Notation by Klaus Lagally #####################################

# $Id: RE.pm,v 1.3 2003/09/02 16:51:09 smrz Exp $

package Encode::Arabic::ArabTeX::ZDMG::RE;

use 5.008;

use strict;
use warnings;

our $VERSION = do { my @r = q$Revision: 1.3 $ =~ /\d+/g; sprintf "%d." . "%02d" x $#r, @r };


sub import {            # perform import as if Encode were used one level before this module
    require Encode;
    Encode->export_to_level(1, @_);
}


use Encode::Encoding;
use base 'Encode::Encoding';

__PACKAGE__->Define('arabtex-zdmg-re', 'ArabTeX-ZDMG-RE');


our (%encode_used, %decode_used, @shams, @qamar);


sub encode ($$;$$) {
    my (undef, $text, $check, $mode) = @_;

    $_[1] = '' if $check;                   # this is what in-place edit needs

    warn 'Encode function is not implemented, _utf8_off($text) returned';

    require Encode;

    return Encode::_utf8_off($text);
}


sub decode ($$;$) {
    my (undef, $text, $check) = @_;

    $_[1] = '' if $check;                   # this is what in-place edit needs

    for ($text) {

        s/NY/n/g;
        s/UA/u\x{0304}/g;
        s/WA/w/g;
        s/_a/a\x{0304}/g;

        s/N/n/g;
        s/Y/a\x{0304}/g;
        s/T/t/g;

        #s/y/j/g;

        s/\\cap\s+([\._\^]?)([a-zAIU])/$1\*$2/g;
        s/\\cap\s+(['`])([a-zAIUEO])/\*$1\*$2/g;

        s/\.(\*?[hsdtz])/$1\x{0323}/g;
        s/\.(\*?g)/$1\x{0307}/g;

        s/_(\*?[td])/$1\x{0331}/g;
        s/_(\*?)h/$1\x{032E}/g;

        #s/_(\*?)h/$1ch/g;

        s/\^(\*?[gs])/$1\x{030C}/g;

        #s/\^(\*?s)/\\v{$1}/g;
        #s/\^(\*?)g/$1d\\v{z}/g;

        s/(?<!\*)([AUEO])/\l$1\x{0304}/g;
        s/(?<!\*)I/\x{0131}\x{0304}/g;
        s/\*([AIUEO])/$1\x{0304}/g;

        s/\*?'/\x{02BE}/g;
        s/\*?`/\x{02BF}/g;

        s/\*([a-z])/\u$1/g;
    }

    return $text;
}


1;

__END__


=head1 NAME

Encode::Arabic::ArabTeX::ZDMG::RE - Deprecated Encode::Arabic::ArabTeX::ZDMG implemented with regular expressions

=head1 REVISION

    $Revision: 1.3 $        $Date: 2003/09/02 16:51:09 $


=head1 SYNOPSIS

    use Encode::Arabic::ArabTeX::ZDMG::RE;

    $string = decode 'arabtex-zdmg-re', $octets;
    $octets = encode 'arabtex-zdmg-re', $string;    # not implemented, returns _utf8_off($string)


=head1 DESCRIPTION

Deprecated method using sequential regular-expression substitutions. Limited in scope over the ArabTeX notation
and non-efficient in data processing, still, not requiring the L<Encode::Mapper|Encode::Mapper> module.

Originally, the method helped data typesetting in TeX. If has been modified to produce correct Perl's
representation engaging Combining Diacritical Marks from the Unicode Standard, Version 4.0.


=head2 EXPORT

Exports as if C<use Encode> also appeared in the package.


=head1 SEE ALSO

L<Encode::Arabic::ArabTeX::ZDMG|Encode::Arabic::ArabTeX::ZDMG>


=head1 AUTHOR

Otakar Smrz, L<http://ckl.mff.cuni.cz/smrz/>

    eval { 'E<lt>' . 'smrz' . "\x40" . ( join '.', qw 'ckl mff cuni cz' ) . 'E<gt>' }

Perl is also designed to make the easy jobs not that easy ;)


=head1 COPYRIGHT AND LICENSE

Copyright 2003 by Otakar Smrz

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut
