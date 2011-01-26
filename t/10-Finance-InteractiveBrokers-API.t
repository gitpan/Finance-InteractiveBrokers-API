#!perl -T
#
#   Finance::InteractiveBrokers::API - Tests for main module
#
#   Copyright (c) 2010-2011 Jason McManus
#

use Data::Dumper;
use Test::More tests => 20;
use strict;
use warnings;

###
### Vars
###

use vars qw( $TRUE $FALSE $VERSION );
BEGIN {
    $VERSION = '0.02';
}

*TRUE      = \1;
*FALSE     = \0;

my $obj;

###
### Tests
###

# Uncomment for use tests
BEGIN {
    use_ok( 'Finance::InteractiveBrokers::API' ) || print "Bail out!";
}

################################################################
# Test: Class method 'api_versions' works
# Expected: PASS
my @junk1 = Finance::InteractiveBrokers::API::api_versions();
cmp_ok( @junk1, '>', 0,                 'Class method api_versions() works' );
my @junk2 = Finance::InteractiveBrokers::API::versions();
cmp_ok( @junk2, '>', 0,                 'Class method alias versions() works' );
is_deeply( \@junk1, \@junk2,            'Both return same values' );

################################################################
# Test: Invalid version fails
# Expected: FAIL
eval {
    $obj = Finance::InteractiveBrokers::API->new( version => 'froofroo' );
};
is( $obj, undef,                        'Object is correctly undef' );
like( $@, qr/^API version 'froofroo' is unknown/,
                                        'Invalid version fails as expected' );

################################################################
# Test: No version passes, defaults to 9.64
# Expected: PASS
isa_ok( $obj = Finance::InteractiveBrokers::API->new(),
                                        'Finance::InteractiveBrokers::API' );

################################################################
# Test: Specific version passed
# Expected: PASS
isa_ok( $obj = Finance::InteractiveBrokers::API->new( version => '9.64' ),
                                        'Finance::InteractiveBrokers::API' );

################################################################
# Tests: Rest of object functions correctly
# Expected: PASS
is( $obj->api_version(), '9.64',                    'api_version()' );
is( $obj->version(), '9.64',                        'version()' );
cmp_ok( my @meths = $obj->methods(), '>', 0,        'methods()' );
cmp_ok( my @evs   = $obj->events(),  '>', 0,        'events()' );
is( my @all = $obj->everything(), scalar( @meths ) + scalar( @evs ),
                                                    'everything()' );
is( $obj->is_method( 'reqCurrentTime' ), $TRUE,     'is_method()' );
is( $obj->is_event( 'currentTime' ),     $TRUE,     'is_event()' );
is( $obj->in_api( 'eConnect' ),          $TRUE,     'in_api() method' );
is( $obj->in_api( 'currentTime' ),       $TRUE,     'in_api() event' );
is( $obj->is_method( 'akiwqlQRZWRQWw' ), $FALSE,    'is_method() invalid' );
is( $obj->is_event( 'AJRKAJNWNRR' ),     $FALSE,    'is_event() invalid' );
is( $obj->in_api( 'GOARWPW' ),           $FALSE,    'in_api() invalid' );

# Always return true
1;

__END__
