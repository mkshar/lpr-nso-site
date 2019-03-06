-module( xlib_align_tests ).

-include( "eunit" ).

-import( xlib_align, [ padding_size/2, align/2, align/3 ] ).

padding_size_test() ->
	
	7 = padding_size(  1, 8 ),
	6 = padding_size( 10, 8 ),
	5 = padding_size( 11, 8 ),
	4 = padding_size( 84, 8 ),
	3 = padding_size( 85, 8 ),
	2 = padding_size( 86, 8 ),
	1 = padding_size(  7, 8 ),
	0 = padding_size(  8, 8 ),
	
	ok
.

align2_test() ->
	
	Block_size = 8,
	
	Aligned = align
	(
		<< 0, 1 >>,
		Block_size
	),
	Block_size = byte_size( Aligned ),
	<< 0, 1, 0, 0, 0, 0, 0, 0 >> = Aligned,
	
	ok
.

align3_test() ->
	
	Block_size = 8,
	
	Aligned_1 = align
	(
		<< 0, 1 >>,
		Block_size,
		fun( Padding_size ) ->
			crypto:strong_rand_bytes( Padding_size )
		end
	),
	Block_size = byte_size( Aligned_1 ),
	<< 0, 1, _Rest /binary >> = Aligned_1,
	
	Aligned_2 = align
	(
		<< 0, 1 >>,
		Block_size,
		fun( Padding_size ) ->
			list_to_binary( lists:duplicate( Padding_size, 0 ) )
		end
	),
	Block_size = byte_size( Aligned_2 ),
	<< 0, 1, 0, 0, 0, 0, 0, 0 >> = Aligned_2,	
	
	ok
.

% EOF
