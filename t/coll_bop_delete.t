#!/usr/bin/perl

use strict;
#use Test::More tests => 49;
use Test::More tests => 36;
use FindBin qw($Bin);
use lib "$Bin/lib";
use MemcachedTest;

=head
get bkey1: END
bop insert bkey1 0x090909090909090909 6 create 11 0 0 datum9: CREATED_STORED
bop insert bkey1 0x07070707070707 6 datum7: STORED
bop insert bkey1 0x0505050505 6 datum5: STORED
bop insert bkey1 0x030303 0x0303 6 datum3: STORED
bop insert bkey1 0x01 0x01 6 datum1: STORED
bop insert bkey1 0x0202 0x02 6 datum2: STORED
bop insert bkey1 0x04040404 0x0404 6 datum4: STORED
bop insert bkey1 0x060606060606 6 datum6: STORED
bop insert bkey1 0x0808080808080808 6 datum8: STORED
bop get bkey1 0x00..0xFF == 11 9 ebkeys eflags values
bop delete bkey1 5: BKEY_MISMATCH
bop delete bkey1 0..9: BKEY_MISMATCH
bop delete bkey1 0..0xFF: CLIENT_ERROR bad command line format
bop delete bkey1 0x00..0xFFF: CLIENT_ERROR bad command line format
bop delete bkey1 0x11..0xFFFF: NOT_FOUND_ELEMENT
bop delete bkey1 0x00..0xFF 1 EQ 0x05: NOT_FOUND_ELEMENT
bop delete bkey1 0x00..0xFF 32 EQ 0x05: CLIENT_ERROR bad command line format
bop delete bkey1 0x00..0xFF 1 XX 0x05: CLIENT_ERROR bad command line format
bop delete bkey1 0x00..0xFF 0 & 0xFFFFFF EQ 0x03: CLIENT_ERROR bad command line format
bop delete bkey1 0x00..0xFF 0 & 0xFFFFFF EQ 0x030303: NOT_FOUND_ELEMENT
bop delete bkey1 0x00..0xFF 1 * 0x00 EQ 0x03 1 1: CLIENT_ERROR bad command line format
bop delete bkey1 0x00..0xFF 3 GT 0x00: NOT_FOUND_ELEMENT
bop delete bkey1 0x0505050505 0 & 0x00 EQ 0x00: NOT_FOUND_ELEMENT
bop delete bkey1 0x00..0xFF 1 & 0xFF EQ 0x03: DELETED
bop get bkey1 0x00..0xFF == 11 8 ebkeys eflags values
bop delete bkey1 0x00..0xFF 0 ^ 0x10 EQ 0x11: DELETED
bop get bkey1 0x00..0xFF == 11 7 ebkeys eflags values
bop delete bkey1 0x00..0xFF 0 LE 0x04: DELETED
bop get bkey1 0x00..0xFF == 11 5 ebkeys eflags values
bop delete bkey1 0xFFFF..0x0000 2 drop: DELETED
bop get bkey1 0x00..0xFF == 11 3 ebkeys eflags values
bop delete bkey1 0x0505050505 0 & 0x00 NE 0x00 drop: DELETED
bop get bkey1 0x00..0xFF == 11 2 ebkeys eflags values
bop delete bkey1 0xFF..0x00 drop: DELETED_DROPPED
get bkey1: END
bop insert bkey1 0 0x0011 6 create 11 0 10 datum0: CREATED_STORED
bop insert bkey1 1 0x0022 6 datum1: STORED
bop insert bkey1 2 0x0A11 6 datum2: STORED
bop insert bkey1 3 0x0AFF 6 datum3: STORED
bop insert bkey1 4 0xBB77 6 datum4: STORED
bop insert bkey1 5 0xCC 6 datum5: STORED
bop get bkey1 0..10 == 11 6 ebkeys eflags values
bop delete bkey1 0..10 0 EQ 0x0011,0xBB77: DELETED
bop get bkey1 0..10 == 11 4 ebkeys eflags values
bop delete bkey1 0..10 0 NE 0x0022,0x0A11: DELETED
bop get bkey1 0..10 == 11 2 ebkeys eflags values
bop delete bkey1 0..10 drop: DELETED_DROPPED
get bkey1: END
=cut

my $server = new_memcached();
my $sock = $server->sock;

my $cmd;
my $val;
my $rst;

# Initialize
$cmd = "get bkey1"; $rst = "END";
print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
# Success Cases
$cmd = "bop insert bkey1 0x090909090909090909 6 create 11 0 0"; $val = "datum9"; $rst = "CREATED_STORED";
print $sock "$cmd\r\n$val\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd $val: $rst");
$cmd = "bop insert bkey1 0x07070707070707 6"; $val = "datum7"; $rst = "STORED";
print $sock "$cmd\r\n$val\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd $val: $rst");
$cmd = "bop insert bkey1 0x0505050505 6"; $val = "datum5"; $rst = "STORED";
print $sock "$cmd\r\n$val\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd $val: $rst");
$cmd = "bop insert bkey1 0x030303 0x0303 6"; $val = "datum3"; $rst = "STORED";
print $sock "$cmd\r\n$val\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd $val: $rst");
$cmd = "bop insert bkey1 0x01 0x01 6"; $val = "datum1"; $rst = "STORED";
print $sock "$cmd\r\n$val\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd $val: $rst");
$cmd = "bop insert bkey1 0x0202 0x02 6"; $val = "datum2"; $rst = "STORED";
print $sock "$cmd\r\n$val\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd $val: $rst");
$cmd = "bop insert bkey1 0x04040404 0x0404 6"; $val = "datum4"; $rst = "STORED";
print $sock "$cmd\r\n$val\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd $val: $rst");
$cmd = "bop insert bkey1 0x060606060606 6"; $val = "datum6"; $rst = "STORED";
print $sock "$cmd\r\n$val\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd $val: $rst");
$cmd = "bop insert bkey1 0x0808080808080808 6"; $val = "datum8"; $rst = "STORED";
print $sock "$cmd\r\n$val\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd $val: $rst");
bop_ext_get_is($sock, "bkey1 0x00..0xFF", 11, 9,
               "0x01,0x0202,0x030303,0x04040404,0x0505050505,0x060606060606,0x07070707070707,0x0808080808080808,0x090909090909090909",
               "0x01,0x02,0x0303,0x0404,,,,,",
               "datum1,datum2,datum3,datum4,datum5,datum6,datum7,datum8,datum9", "END");
# Fail Cases
$cmd = "bop delete bkey1 5"; $rst = "BKEY_MISMATCH";
print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
$cmd = "bop delete bkey1 0..9"; $rst = "BKEY_MISMATCH";
print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
$cmd = "bop delete bkey1 0..0xFF"; $rst = "CLIENT_ERROR bad command line format";
print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
$cmd = "bop delete bkey1 0x00..0xFFF"; $rst = "CLIENT_ERROR bad command line format";
print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
$cmd = "bop delete bkey1 0x11..0xFFFF"; $rst = "NOT_FOUND_ELEMENT";
print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
$cmd = "bop delete bkey1 0x00..0xFF 1 EQ 0x05"; $rst = "NOT_FOUND_ELEMENT";
print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
$cmd = "bop delete bkey1 0x00..0xFF 32 EQ 0x05"; $rst = "CLIENT_ERROR bad command line format";
print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
$cmd = "bop delete bkey1 0x00..0xFF 1 XX 0x05"; $rst = "CLIENT_ERROR bad command line format";
print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
$cmd = "bop delete bkey1 0x00..0xFF 0 & 0xFFFFFF EQ 0x03"; $rst = "CLIENT_ERROR bad command line format";
print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
$cmd = "bop delete bkey1 0x00..0xFF 0 & 0xFFFFFF EQ 0x030303"; $rst = "NOT_FOUND_ELEMENT";
print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
$cmd = "bop delete bkey1 0x00..0xFF 1 * 0x00 EQ 0x03 1 1"; $rst = "CLIENT_ERROR bad command line format";
print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
$cmd = "bop delete bkey1 0x00..0xFF 3 GT 0x00"; $rst = "NOT_FOUND_ELEMENT";
print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
$cmd = "bop delete bkey1 0x0505050505 0 & 0x00 EQ 0x00"; $rst = "NOT_FOUND_ELEMENT";
print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
# Success Cases
$cmd = "bop delete bkey1 0x00..0xFF 1 & 0xFF EQ 0x03"; $rst = "DELETED";
print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
bop_ext_get_is($sock, "bkey1 0x00..0xFF", 11, 8,
               "0x01,0x0202,0x04040404,0x0505050505,0x060606060606,0x07070707070707,0x0808080808080808,0x090909090909090909",
               "0x01,0x02,0x0404,,,,,",
               "datum1,datum2,datum4,datum5,datum6,datum7,datum8,datum9", "END");
$cmd = "bop delete bkey1 0x00..0xFF 0 ^ 0x10 EQ 0x11"; $rst = "DELETED";
print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
bop_ext_get_is($sock, "bkey1 0x00..0xFF", 11, 7,
               "0x0202,0x04040404,0x0505050505,0x060606060606,0x07070707070707,0x0808080808080808,0x090909090909090909",
               "0x02,0x0404,,,,,",
               "datum2,datum4,datum5,datum6,datum7,datum8,datum9", "END");
$cmd = "bop delete bkey1 0x00..0xFF 0 LE 0x04"; $rst = "DELETED";
print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
bop_ext_get_is($sock, "bkey1 0x00..0xFF", 11, 5,
               "0x0505050505,0x060606060606,0x07070707070707,0x0808080808080808,0x090909090909090909", ",,,,",
               "datum5,datum6,datum7,datum8,datum9", "END");
$cmd = "bop delete bkey1 0xFFFF..0x0000 2 drop"; $rst = "DELETED";
print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
bop_ext_get_is($sock, "bkey1 0x00..0xFF", 11, 3,
               "0x0505050505,0x060606060606,0x07070707070707", ",,",
               "datum5,datum6,datum7", "END");
$cmd = "bop delete bkey1 0x0505050505 0 & 0x00 NE 0x00 drop"; $rst = "DELETED";
print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
bop_ext_get_is($sock, "bkey1 0x00..0xFF", 11, 2,
               "0x060606060606,0x07070707070707", ",",
               "datum6,datum7", "END");
$cmd = "bop delete bkey1 0xFF..0x00 drop"; $rst = "DELETED_DROPPED";
print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
# Finalize
$cmd = "get bkey1"; $rst = "END";
print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");

# #Success Cases
# $cmd = "bop insert bkey1 0 0x0011 6 create 11 0 10"; $val = "datum0"; $rst = "CREATED_STORED";
# print $sock "$cmd\r\n$val\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd $val: $rst");
# $cmd = "bop insert bkey1 1 0x0022 6"; $val = "datum1"; $rst = "STORED";
# print $sock "$cmd\r\n$val\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd $val: $rst");
# $cmd = "bop insert bkey1 2 0x0A11 6"; $val = "datum2"; $rst = "STORED";
# print $sock "$cmd\r\n$val\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd $val: $rst");
# $cmd = "bop insert bkey1 3 0x0AFF 6"; $val = "datum3"; $rst = "STORED";
# print $sock "$cmd\r\n$val\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd $val: $rst");
# $cmd = "bop insert bkey1 4 0xBB77 6"; $val = "datum4"; $rst = "STORED";
# print $sock "$cmd\r\n$val\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd $val: $rst");
# $cmd = "bop insert bkey1 5 0xCC 6"; $val = "datum5"; $rst = "STORED";
# print $sock "$cmd\r\n$val\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd $val: $rst");
# #check
# bop_ext_get_is($sock, "bkey1 0..10", 11, 6,
# "0,1,2,3,4,5", "0x0011,0x0022,0x0A11,0x0AFF,0xBB77,0xCC",
# "datum0,datum1,datum2,datum3,datum4,datum5","END" );
#
# $cmd = "bop delete bkey1 0..10 0 EQ 0x0011,0xBB77"; $rst = "DELETED";
# print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
# #check
# bop_ext_get_is($sock, "bkey1 0..10", 11, 4,
# "1,2,3,5", "0x0022,0x0A11,0x0AFF,0xCC",
# "datum1,datum2,datum3,datum5", "END");
#
# $cmd = "bop delete bkey1 0..10 0 NE 0x0022,0x0A11"; $rst = "DELETED";
# print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
# #check
# bop_ext_get_is($sock, "bkey1 0..10", 11, 2,
# "1,2", "0x0022,0x0A11",
# "datum1,datum2","END");
#
# $cmd = "bop delete bkey1 0..10 drop"; $rst = "DELETED_DROPPED";
# print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
# # Finalize
# $cmd = "get bkey1"; $rst = "END";
# # print $sock "$cmd\r\n"; is(scalar <$sock>, "$rst\r\n", "$cmd: $rst");
