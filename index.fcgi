#!/usr/bin/perl -w

# ###################################################################### Otakar Smrz, 2003/01/23
#
# Encodings of Arabic ##########################################################################

# $Id: index.fcgi,v 1.2 2004/01/12 21:48:49 smrz Exp $

our $VERSION = do { my @r = q$Revision: 1.2 $ =~ /\d+/g; sprintf "%d." . "%02d" x $#r, @r };


use lib '/usr/lib/perl5/5.8.2/i386-linux-thread-multi',
        '/home/smrz/lib/perl5/site_perl/5.8.0';

use CGI::Fast ':standard';

use Benchmark;

BEGIN { @tick = (new Benchmark) }

use Encode::Arabic;
use Encode::Arabic::ArabTeX ':xml';
use Encode::Arabic::ArabTeX::ZDMG ':xml';


sub timer (@) { return sprintf "%04d/%02d/%02d %02d:%02d:%02d <GMT>",
                       $_[5] + 1900, $_[4] + 1, @_[3, 2, 1, 0] }

sub tick () { push @tick, new Benchmark }

sub escape ($) { my $x = shift; for ($x) { s/\&/\&amp;/g; s/\</\&lt;/g; s/\>/\&gt;/g } $x }

#sub revert ($) { my $x = shift; for ($x) { s/\&gt;/\>/g; s/\&lt;/\</g; s/\&amp;/\&/g } $x }


$enc_text = "\\cap iqra' h_a_dA an-na.s.sa bi-intibAhiN. \\cap kayfa al-.hAlu? \\cap al-'Ana " .
            (timer gmtime time) . ", 'ahlaN wa sahlaN!";

%enc_hash = (
                 'ArabTeX',            'Encode::Arabic::ArabTeX' ,
                 'ArabTeX-RE',         '' ,
                 'ArabTeX-ZDMG',       'Encode::Arabic::ArabTeX::ZDMG' ,
                 'ArabTeX-ZDMG-RE',    '' ,
                 'Buckwalter',         '' ,
                 'UTF-8',              '' ,
        );

@enc_list = ( reverse sort keys %enc_hash );
$enc_list = -3;

@type_list = ('Character Data', 'HTML Character Decimal', 'Perl Byte Hexadecimal');
$type_list = 0;


while ($q = new CGI::Fast) {

    $q->charset('utf-8');

    print $q->header('-type' => 'text/html', '-charset' => $q->charset(), '-expires' => 'now');

    print $q->start_html('-title' => "Encode::Arabic $Encode::Arabic::VERSION Online Interface", '-encoding' => $q->charset(),
                         '-style' => {'-src' => 'http://ckl.mff.cuni.cz/smrz/Encode/Arabic/encode.css', '-type' => 'text/css'});

    $start_form = $q->start_form('-method' => 'POST');

    $start_form =~ s/( action="[^"]+)"/$1#see"/;

    print $start_form;

    print $q->hidden('session', $$);


    unless (defined $q->param('session')) {

        $q->param('text', $enc_text);

        $q->param('dec_code', $enc_list[$enc_list]);
        $q->param('enc_code', @enc_list);

        $q->param('dec_type', $type_list[$type_list]);

        $q->param('enc_type', @type_list);

        $q->param('repeat', '   1');
    }
    else {

        $q->param('enc_type', $type_list[0], $q->param('enc_type'));
    }

    %type_hash = ( map { $_, 1 } $q->param('enc_type') );


    print $q->h1($q->a({'href'=>'http://search.cpan.org/dist/Encode-Arabic/'}, "Encode::Arabic $Encode::Arabic::VERSION"), 'Online Interface');

    tick;
    $enc_hash{$q->param('dec_code')}->decoder('options' => [':xml']) if $enc_hash{$q->param('dec_code')};
    $enc_hash{$_} and $enc_hash{$_}->encoder() foreach $q->param('enc_code');
    tick;

    print $q->p('Initialization', timestr timediff $tick[-1], $tick[-2]);
    print $q->p($q->i('The time is needed to compile the',
                      $q->a({href=>'http://search.cpan.org/dist/Encode-Mapper/'}, 'Encode::Mapper'), 'engines.',
                      'It is done once per request due to this interface, unless bridged with FastCGI',
                      '... the processing itself is quick!'));
    print $q->p($q->i('You must have Unicode fonts installed to appreciate this site. Try',
                      $q->a({href=>'http://prdownloads.sourceforge.net/vietunicode/arialuni.zip'},
                            'Arial Unicode MS'), 'from Sourceforge.'));


    print $q->h2('Your Request');

    print $q->table(
                {-border=>0, -width=>"100%"},
                Tr(
                    {-align=>left,-valign=>middle},
                [
                    td(
                        {-colspan=>2},
                        [ #'Text',
                          $q->textfield(-name       =>  'text',
                                      -default    =>  $enc_text,
                                      -size       =>  180,
                                      -maxlength  =>  300
                            ) ]
                    ),

                    td(
                        [ 'Decode Setting',
                          table(
                                {-border=>0, -width=>"100%"},
                                Tr(
                                    {-align=>left,-valign=>top},
                                [
                                    td(
                                        [ $q->radio_group(-name      =>  'dec_code',
                                                        -values    =>  [ reverse @enc_list ],
                                                        -default   =>  $enc_list[$enc_list],
                                                        -linebreak =>  0,
                                                        -rows      =>  1,
                                                        -columns   =>  6,
                                                ) ]
                                    ),

                                    td(
                                        [ $q->radio_group(-name      =>  'dec_type',
                                                        -values    =>  [ @type_list ],
                                                        -default   =>  $type_list[$type_list],
                                                        -linebreak =>  0,
                                                        -rows      =>  1,
                                                        -columns   =>  3,
                                                ) ]
                                    ),
                                ])
                            )]
                        ),

                    td(
                        [ 'Encode Setting',
                          table(
                                {-border=>0, -width=>"100%"},
                                Tr(
                                    {-align=>left,-valign=>top},
                                [
                                    td(
                                        [ $q->checkbox_group(-name      =>  'enc_code',
                                                        -values    =>  [ @enc_list ],
                                                        -default   =>  [ @enc_list ],
                                                        -linebreak =>  0,
                                                        -rows      =>  1,
                                                        -columns   =>  6,
                                                ) ]
                                    ),

                                    td(
                                        [ map { s?"Character Data"?"Character Data" disabled="disabled"?; $_ }
                                          $q->checkbox_group(-name      =>  'enc_type',
                                                        -values    =>  [ @type_list ],
                                                        -default   =>  [ @type_list ],
                                                        -linebreak =>  0,
                                                        -rows      =>  1,
                                                        -columns   =>  3,
                                                ) ]
                                    ),
                                ])
                            )]
                        ),


                  td(
                      [ 'Iterations',
                          table(
                                {-border=>0, -width=>"100%"},
                                Tr(
                                    {-align=>left,-valign=>top},
                                [
                                    td(

                        [ $q->radio_group(-name      =>  'repeat',
                            -values     =>  [ map { sprintf "%4d", $_ } 1, 2, 4, 10, 20, 40, 100, 200, 400, 1000, 2000, 4000 ],
                            -default    =>  0,
                            -rows       =>  1,
                            -columns    =>  12,
                            )]

                                    ),
                                ])
                            )]
                        ),

    #print $q->popup_menu(-name      =>  'enc',
    #                     -values    =>  [ @enc_list ],
    #                     -default   =>  $enc_list[$enc_list]);


    #print $q->popup_menu(-name      =>  'type',
    #                     -values    =>  [ 'Character Data', 'HTML Character Decimal', 'Perl Byte Hexadecimal' ],
    #                     -default   =>  'Character Data');

                ])
            );

    print $q->table(
                    {-border=>0, -width=>"100%"},
                    Tr(
                        {-align=>left,-valign=>middle},
                    [
                        td(
                            [
                                $q->submit(-name => 'submit', -value => 'Decode/Encode'),
                                $q->reset('Reset Current'),
                                $q->defaults('Demo Request'),
                            ]
                        )
                    ])
            );


    print $q->br({-id => 'see'});;


    print $q->h2('Decoding Business');

    $dec_text = $q->param('text');

    if ($q->param('dec_type') eq 'HTML Character Decimal') {

        $dec_text = pack "U( U)*", $dec_text =~ /\&\#(\d+)\;/g;

        if ($dec_text =~ /^\x00/) {
            $dec_text = '';
        }
        else {
            Encode::_utf8_off $dec_text;
        }
    }
    elsif ($q->param('dec_type') eq 'Perl Byte Hexadecimal') {

        $dec_text = join "", map {
                            /^\{(.*)\}/ ? pack "U", hex $1 : pack "C", hex $_
                        } $dec_text =~ /\\x(\{[0-9A-Fa-f]+\}|[0-9A-Fa-f][0-9A-Fa-f])/g;

        if ($dec_text =~ /^\x00/) {
            $dec_text = '';
        }
        else {
            Encode::_utf8_off $dec_text;
        }
    }


    print $q->h3(
                    {
                        -class => (Encode::is_utf8($dec_text) ? $dec_text : decode 'utf8', $dec_text) =~ /\p{Arabic}/ ?
                                    'arabic' : ''
                    },

                    Encode::is_utf8($dec_text) ? escape encode 'utf8', $dec_text :
                                                 $dec_text ne '' ? escape $dec_text : '&nbsp;'
            );

    tick;
    for ($i = 0; $i < $q->param('repeat'); $i++) { $decode = decode $q->param('dec_code'), $dec_text }
    tick;

    print $q->p($q->param('dec_code'), timestr timediff $tick[-1], $tick[-2]);

    print map {
                $_ ne '' ? $q->p($_) : ()
        }
        map {
            ($type_hash{'HTML Character Decimal'} ?
                (join " ", map { sprintf "&amp;#%d;", $_ } unpack "U*", Encode::is_utf8($_) ? $_ : decode 'utf8', $_)
                : () ),
            ($type_hash{'Perl Byte Hexadecimal'} ?
                (join "", map { sprintf "\\x%02X", $_ } unpack "C*", $_)
                : () ),
        } $dec_text;


    print $q->h2('Encoding Business');

    foreach ($q->param('enc_code')) {

        tick;
        for ($i = 0; $i < $q->param('repeat'); $i++) { $encode = encode $_, $decode }
        tick;

        print $q->h3(
                        {
                            -class => (Encode::is_utf8($encode) ? $encode : decode 'utf8', $encode) =~ /\p{Arabic}/ ?
                                        'arabic' : ''
                        },

                        Encode::is_utf8($encode) ? escape encode 'utf8', $encode :
                                                   $encode ne '' ? escape $encode : '&nbsp;'
                );

        print $q->p($_, timestr timediff $tick[-1], $tick[-2]);

        print map {
                $_ ne '' ? $q->p($_) : ()
            }
            map {
                ($type_hash{'HTML Character Decimal'} ?
                    (join " ", map { sprintf "&amp;#%d;", $_ } unpack "U*", Encode::is_utf8($_) ? $_ : decode 'utf8', $_)
                    : () ),
                ($type_hash{'Perl Byte Hexadecimal'} ?
                    (join "", map { sprintf "\\x%02X", $_ } unpack "C*", $_)
                    : () ),
            } $encode;
    }


    print $q->end_form();

    print $q->end_html();

    exit if -M $0 < 0;      # FCGI autorestart trick with Apache
}
