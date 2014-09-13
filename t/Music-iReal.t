# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Music-iReal.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More tests => 4;
BEGIN { use_ok('Music::iReal') };

my $song = Music::iReal->new();
isa_ok($song, 'Music::iReal');

$song->title('Avalon');
$song->composer('Byron');
$song->style('Balboa');
$song->key('D');
$song->transpose('A');
$song->comping_style('Cuban-Cha Cha Cha');
$song->bpm(140);
$song->repeat(8);

$song->add_time('4/4');
ok($song->{body} eq 'T44', 'add_time()');

my $ireal = $song->export();
ok($ireal, "export ireal");

warn $ireal;

TODO: {
    local $TODO = 'not finished';

}



#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

