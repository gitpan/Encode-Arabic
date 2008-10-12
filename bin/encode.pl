#! perl -w

our $VERSION = do { q $Revision: 550 $ =~ /(\d+)/; sprintf "%4.2f", $1 / 100 };

use Encode::Arabic::Buckwalter ':xml';
use Encode::Arabic;

use Getopt::Std;

$Getopt::Std::STANDARD_HELP_VERSION = 1;

$options = { 'p' => '', 's' => '' };

getopts('p:s:v', $options);

die $Encode::Arabic::VERSION . "\n" if exists $options->{'v'};

$e = shift @ARGV;

while (<>) {

    print encode $e, decode "utf8", $options->{'p'} . $_ . $options->{'s'};
}


__END__


=head1 NAME

encode - Filter script mimicking the encode function


=head1 REVISION

    $Revision: 550 $        $Date: 2008-05-06 16:22:13 +0200 (Tue, 06 May 2008) $


=head1 SYNOPSIS

Examples of command-line invocation:

    $ decode ArabTeX < decode.d | encode Buckwalter > encode.d
    $ decode MacArabic < data.MacArabic > data.UTF8
    $ encode WinArabic < data.UTF8 > data.WinArabic

The core of the implementation:

    getopts('p:s:v', $options);

    $e = shift @ARGV;

    while (<>) {

        print encode $e, decode "utf8", $options->{'p'} . $_ . $options->{'s'};
    }


=head1 DESCRIPTION

The L<Encode|Encode> library provides a unified interface for converting strings
from different encodings into a common representation, and vice versa.

The L<encode|encode> and L<decode|decode> programs mimick the fuction calls to
the C<encode> and C<decode> methods, respectively.

For the list of supported encoding schemes, please refer to L<Encode|Encode> and
the source files of the programs. The naming of encodings is case-insensitive.


=head1 OPTIONS

  encode [OPTIONS] encoding
    -v       --version      show program's version
             --help         show usage information
    -p text  --prefix=text  prefix input with text
    -s text  --suffix=text  suffix input with text


=head1 SEE ALSO

Encode::Arabic Online Interface L<http://ufal.mff.cuni.cz/~smrz/Encode/Arabic/>

Encode Arabic Project           L<http://sourceforge.net/projects/encode-arabic/>

ElixirFM Project                L<http://sourceforge.net/projects/elixir-fm/>

L<Encode|Encode>,
L<Encode::Encoding|Encode::Encoding>,
L<Encode::Arabic|Encode::Arabic>


=head1 AUTHOR

Otakar Smrz, L<http://ufal.mff.cuni.cz/~smrz/>

    eval { 'E<lt>' . ( join '.', qw 'otakar smrz' ) . "\x40" . ( join '.', qw 'mff cuni cz' ) . 'E<gt>' }

Perl is also designed to make the easy jobs not that easy ;)


=head1 COPYRIGHT AND LICENSE

Copyright 2003-2008 by Otakar Smrz

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut
