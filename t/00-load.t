#!perl -T

use Test::More tests => 9;

BEGIN {
    use_ok( 'Encode::Mapper' );
    use_ok( 'Encode::Arabic' );
    use_ok( 'Encode::Arabic::ArabTeX' );
    use_ok( 'Encode::Arabic::ArabTeX::RE' );
    use_ok( 'Encode::Arabic::ArabTeX::Verbatim' );
    use_ok( 'Encode::Arabic::ArabTeX::ZDMG' );
    use_ok( 'Encode::Arabic::ArabTeX::ZDMG::RE' );
    use_ok( 'Encode::Arabic::Buckwalter' );
    use_ok( 'Encode::Arabic::Parkinson' );
}

diag( "Testing Encode::Arabic $Encode::Arabic::VERSION" );
