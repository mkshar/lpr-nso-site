-module( xlib_crc16_ccitt_tests ).
-import( xlib_crc16_ccitt, [ compute/2 ] ).

-include( "eunit" ).

vector_1_test() ->

	Test_vector = << 16#01, 16#02, 16#11, 16#22, 16#33, 16#44, 16#00, 16#80, 16#00, 16#00 >>,
	16#9F08 = compute( Test_vector, 0 ),
	16#7E31 = compute( Test_vector, 16#FFFF ),
	
	ok
.

vector_2_test() ->
	
	Test_vector = << 16#31, 16#32, 16#33, 16#34, 16#35, 16#36, 16#37, 16#38, 16#39 >>,
	16#31C3 = compute( Test_vector, 0 ),
	16#29B1 = compute( Test_vector, 16#FFFF ),
	
	ok
.

% EOF
