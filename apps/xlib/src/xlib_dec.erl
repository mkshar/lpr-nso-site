-module( xlib_dec ).
-author( "Mikhail Sharoglazov <sharoglazov@sibext.com>" ).
-version( "0.1" ). % Do NOT set -vsn attribute! It is used to detect code changes by MD5-hashing the module's AST.

-export( [ dec_to_int/1, dec_to_list/1, dec_to_list/2, int_to_dec/1, int_to_dec/2 ] ).

-include( "eunit" ).

dec_digit_to_int( $0 ) -> 0;
dec_digit_to_int( $1 ) -> 1;
dec_digit_to_int( $2 ) -> 2;
dec_digit_to_int( $3 ) -> 3;
dec_digit_to_int( $4 ) -> 4;
dec_digit_to_int( $5 ) -> 5;
dec_digit_to_int( $6 ) -> 6;
dec_digit_to_int( $7 ) -> 7;
dec_digit_to_int( $8 ) -> 8;
dec_digit_to_int( $9 ) -> 9.

int_to_dec( Int ) ->
	list_to_binary( io_lib:format( "~b", [ Int ] ) )
.

int_to_dec( Int, Digits ) ->

	int_to_dec_internal( Int, Digits, [] )
	% alternative implementation:
	%	list_to_binary( io_lib:format( "~*..0b~n", [ Digits, Int ] ) )
.

int_to_dec_internal( Int, 0, A ) ->

	list_to_binary( A )
;

int_to_dec_internal( 0, Digits, A ) ->

	int_to_dec_internal( 0, Digits - 1, [ $0 | A ] )
;

int_to_dec_internal( Int, Digits, A ) ->

	int_to_dec_internal( Int div 10, Digits - 1, [ ( $0 + ( Int rem 10 ) ) | A ] )
.


dec_to_int( Bin ) ->

	dec_to_int( Bin, 0 )
.

dec_to_int( <<>>, A ) ->

	A
;

dec_to_int( << Digit /integer, Rest /binary >>, A ) ->

	dec_to_int( Rest, A * 10 + dec_digit_to_int( Digit ) )
.

dec_to_list( Bin, Unit_size ) ->

	lists:reverse( dec_to_list_internal( Unit_size, Bin, [] ) )
.

dec_to_list( Bin ) ->

	lists:reverse( dec_to_list_internal( Bin, [] ) )
.

dec_to_list_internal( <<>>, A ) ->

	A
;

dec_to_list_internal( << Digits: 2 /binary, Rest /binary >>, A ) ->

	dec_to_list_internal( Rest, [ dec_to_int( Digits ) | A ] )
.

dec_to_list_internal( _Unit_size, <<>>, A ) ->

	A
;

dec_to_list_internal( Unit_size, Bin, A ) ->

	<< Digits: Unit_size /binary, Rest /binary >> = Bin,

	dec_to_list_internal( Unit_size, Rest, [ dec_to_int( Digits ) | A ] )
.

%EOF
