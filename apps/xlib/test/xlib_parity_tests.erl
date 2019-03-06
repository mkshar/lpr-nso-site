-module( xlib_parity_tests ).
-import( xlib_parity, [ set_parity/1 ] ).

-include( "eunit" ).

set_parity_test() ->
	
	<< 1, 1, 1, 1, 1, 1, 1, 1 >> = set_parity( << 0 : ( 8 * 8 ) >> ),
	<< 1, 1, 1, 1, 1, 1, 1, 1 >> = set_parity( << 1, 1, 1, 1, 1, 1, 1, 1 >> ),

	ok
.

des_keys_test() ->

	K1 = << "Pa5Sw0rd" >>,
	K2 = set_parity( K1 ),
	Enc = crypto:block_encrypt( des_cbc, K1, << 0 : 64 >>, "12345678" ),
	Enc = crypto:block_encrypt( des_cbc, K2, << 0 : 64 >>, "12345678" ),
	<< "12345678" >> = crypto:block_decrypt( des_cbc, K2, << 0 : 64 >>, Enc ),
	
	ok
.
