-module( xlib_hex_tests ).
-author( "Mikhail Sharoglazov <sharoglazov@sibext.com>" ).
-version( "0.1" ). % Do NOT set -vsn attribute! It is used to detect code changes by MD5-hashing the module's AST.

-import( xlib_hex, [ hex_to_int/1, hex_to_list/1, binary_to_hex/1, binary_to_dump/1, nibble_to_hex_digit/1, uint8_to_hex/1, uint8_to_hex/2 ] ).

-include( "eunit" ).

one_nibble_to_int_test() ->

	16#0 = hex_to_int( << "0" >> ),
	16#1 = hex_to_int( << "1" >> ),
	16#2 = hex_to_int( << "2" >> ),
	16#3 = hex_to_int( << "3" >> ),
	16#4 = hex_to_int( << "4" >> ),
	16#5 = hex_to_int( << "5" >> ),
	16#6 = hex_to_int( << "6" >> ),
	16#7 = hex_to_int( << "7" >> ),
	16#8 = hex_to_int( << "8" >> ),
	16#9 = hex_to_int( << "9" >> ),
	16#A = hex_to_int( << "A" >> ),
	16#B = hex_to_int( << "B" >> ),
	16#C = hex_to_int( << "C" >> ),
	16#D = hex_to_int( << "D" >> ),
	16#E = hex_to_int( << "E" >> ),
	16#F = hex_to_int( << "F" >> ),
	
	ok
.

one_octet_to_int_test() ->

	16#00 = hex_to_int( << "00" >> ),
	
	16#01 = hex_to_int( << "01" >> ),
	16#0F = hex_to_int( << "0F" >> ),
	
	16#1F = hex_to_int( << "1F" >> ),
	16#F1 = hex_to_int( << "F1" >> ),
	
	16#10 = hex_to_int( << "10" >> ),
	16#F0 = hex_to_int( << "F0" >> ),
	
	16#FF = hex_to_int( << "FF" >> ),
	
	ok
.

one_octet_to_list_test() ->

	[ 16#00 ] = hex_to_list( << "00" >> ),
	
	[ 16#01 ] = hex_to_list( << "01" >> ),
	[ 16#0F ] = hex_to_list( << "0F" >> ),
	
	[ 16#1F ] = hex_to_list( << "1F" >> ),
	[ 16#F1 ] = hex_to_list( << "F1" >> ),
	
	[ 16#10 ] = hex_to_list( << "10" >> ),
	[ 16#F0 ] = hex_to_list( << "F0" >> ),
	
	[ 16#FF ] = hex_to_list( << "FF" >> ),
	
	ok
.

four_octets_to_list_test() ->

	[ 16#00, 16#01, 16#10, 16#FF ] = hex_to_list( << "00" "01" "10" "FF" >> ),

	ok
.

binary_to_hex_test() ->

	<< "00010f10f0ff" >> = binary_to_hex( << 16#00, 16#01, 16#0F, 16#10, 16#F0, 16#FF >> ),

	ok
.

binary_to_dump_test() ->

	<< "00:01:0f:10:f0:ff" >> = binary_to_dump( << 16#00, 16#01, 16#0F, 16#10, 16#F0, 16#FF >> ),

	ok
.

nibble_to_hex_test() ->

	$0 = nibble_to_hex_digit( 0 ),
	$9 = nibble_to_hex_digit( 9 ),
	$a = nibble_to_hex_digit( 16#0A ),
	$f = nibble_to_hex_digit( 16#0F ),

	ok
.

uint8_to_hex_test() ->

	<<"00">> = uint8_to_hex( 16#00 ),
	<<"08">> = uint8_to_hex( 16#08 ),
	<<"50">> = uint8_to_hex( 16#50 ),
	<<"ff">> = uint8_to_hex( 16#FF ),
	<<"ff">> = uint8_to_hex( 16#FF, lower ),
	<<"FF">> = uint8_to_hex( 16#FF, upper ),
	
	ok
.

%EOF