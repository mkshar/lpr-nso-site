-module( xlib_hex ).
-author( "Mikhail Sharoglazov <sharoglazov@sibext.com>" ).
-version( "0.1" ). % Do NOT set -vsn attribute! It is used to detect code changes by MD5-hashing the module's AST.

-export( [ hex_to_int/1, hex_to_binary/1, hex_to_list/1, hex_to_list/2, binary_to_hex/1, binary_to_dump/1, nibble_to_hex_digit/1, uint8_to_hex/1, uint8_to_hex/2 ] ).

-include( "eunit" ).

hex_digit_to_int( $0 ) -> 16#0;
hex_digit_to_int( $1 ) -> 16#1;
hex_digit_to_int( $2 ) -> 16#2;
hex_digit_to_int( $3 ) -> 16#3;
hex_digit_to_int( $4 ) -> 16#4;
hex_digit_to_int( $5 ) -> 16#5;
hex_digit_to_int( $6 ) -> 16#6;
hex_digit_to_int( $7 ) -> 16#7;
hex_digit_to_int( $8 ) -> 16#8;
hex_digit_to_int( $9 ) -> 16#9;
hex_digit_to_int( $A ) -> 16#A;
hex_digit_to_int( $B ) -> 16#B;
hex_digit_to_int( $C ) -> 16#C;
hex_digit_to_int( $D ) -> 16#D;
hex_digit_to_int( $E ) -> 16#E;
hex_digit_to_int( $F ) -> 16#F;
hex_digit_to_int( $a ) -> 16#A;
hex_digit_to_int( $b ) -> 16#B;
hex_digit_to_int( $c ) -> 16#C;
hex_digit_to_int( $d ) -> 16#D;
hex_digit_to_int( $e ) -> 16#E;
hex_digit_to_int( $f ) -> 16#F.

hex_to_int( Bin ) ->

	hex_to_int( Bin, 0 )
.

hex_to_int( <<>>, A ) ->

	A
;

hex_to_int( << Hex_digit /integer, Rest /binary >>, A ) ->

	hex_to_int( Rest, A * 16 + hex_digit_to_int( Hex_digit ) )
.

hex_to_list( Bin, Unit_size ) ->

	lists:reverse( hex_to_list_internal( Unit_size, Bin, [] ) )
.

hex_to_list( Bin ) ->

	lists:reverse( hex_to_list_internal( Bin, [] ) )
.

hex_to_binary( Hex ) ->

	list_to_binary( hex_to_list( Hex ) )
.

hex_to_list_internal( <<>>, A ) ->

	A
;

hex_to_list_internal( << Hex: 2 /binary, Rest /binary >>, A ) ->

	hex_to_list_internal( Rest, [ hex_to_int( Hex ) | A ] )
.

hex_to_list_internal( _Unit_size, <<>>, A ) ->

	A
;

hex_to_list_internal( Unit_size, Bin, A ) ->

	<< Hex: Unit_size /binary, Rest /binary >> = Bin,

	hex_to_list_internal( Unit_size, Rest, [ hex_to_int( Hex ) | A ] )
.

nibble_to_hex_digit_internal( Nibble, Hex_digit_base ) ->
	if
		Nibble < 10 -> Nibble + $0;
		true -> Nibble + Hex_digit_base - 10
	end
.

nibble_to_hex_digit( Nibble )        -> nibble_to_hex_digit_internal( Nibble, $a ).

nibble_to_hex_digit( Nibble, lower ) -> nibble_to_hex_digit_internal( Nibble, $a );
nibble_to_hex_digit( Nibble, upper ) -> nibble_to_hex_digit_internal( Nibble, $A ).

uint8_to_hex( Int ) ->

	uint8_to_hex_internal( Int, lower )
.

uint8_to_hex( Int, Charset ) ->

	uint8_to_hex_internal( Int, Charset )
.

uint8_to_hex_internal( Int, Charset ) ->

	Hi_nibble = nibble_to_hex_digit( Int div 16, Charset ),
	Lo_nibble = nibble_to_hex_digit( Int rem 16, Charset ),

	<< Hi_nibble : 8 /integer, Lo_nibble : 8 /integer >>
.

binary_to_dump( Bin ) ->

	binary_to_dump_internal( Bin, <<>> )
.

binary_to_dump_internal( Bin ) ->

	<< Hi_nibble : 4 /integer, Lo_nibble : 4 /integer, Rest /binary  >> = Bin,
	
	{
		nibble_to_hex_digit( Hi_nibble ),
		nibble_to_hex_digit( Lo_nibble ),
		Rest
	}
.

binary_to_dump_internal( <<>>, A ) ->

	A
;

binary_to_dump_internal( Bin, <<>> ) ->

	{ Hi_nibble, Lo_nibble, Rest } = binary_to_dump_internal( Bin ),

	binary_to_dump_internal( Rest, << Hi_nibble : 8 /integer, Lo_nibble : 8 /integer >> )
;

binary_to_dump_internal( Bin, A ) ->

	{ Hi_nibble, Lo_nibble, Rest } = binary_to_dump_internal( Bin ),

	binary_to_dump_internal( Rest, << A /binary, ":" : 8 /integer, Hi_nibble : 8 /integer, Lo_nibble : 8 /integer >> )
.

binary_to_hex( Bin ) ->

	binary_to_hex_internal( Bin, <<>> )
.

binary_to_hex_internal( <<>>, A ) ->

	A
;

binary_to_hex_internal( Bin, A ) ->

	<< Nibble : 4 /integer, Rest /bitstring  >> = Bin,
	Hex = nibble_to_hex_digit( Nibble ),
	
	binary_to_hex_internal( Rest, << A /binary, Hex : 8 /integer >> )
.

%EOF
