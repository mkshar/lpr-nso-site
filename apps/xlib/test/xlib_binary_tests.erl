-module( xlib_binary_tests ).
-import( xlib_binary, [ bxor_binaries/2 ] ).

-include( "eunit" ).

xor_pair_1_test() ->
	
	In_1 = << 2#00000000, 2#00000000 >>,
	In_2 = << 2#11111111, 2#11111111 >>,
	Res  = << 2#11111111, 2#11111111 >>,
	Res  = bxor_binaries( In_1, In_2 ),
	
	ok
.

xor_pair_2_test() ->
	In_1 = << 2#00000001, 2#00000001 >>,
	In_2 = << 2#11111111, 2#11111111 >>,
	Res  = << 2#11111110, 2#11111110 >>,
	Res  = bxor_binaries( In_1, In_2 ),
	
	ok
.

xor_pair_3_test() ->
	In_1 = << 2#00000001, 2#00000001, 2#10101010 >>,
	In_2 = << 2#11111111, 2#11111111 >>,
	Res  = << 2#11111110, 2#11111110, 2#10101010 >>,
	Res  = bxor_binaries( In_1, In_2 ),
	
	ok
.

% EOF
