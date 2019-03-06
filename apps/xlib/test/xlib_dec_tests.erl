-module( xlib_dec_tests ).
-author( "Mikhail Sharoglazov <sharoglazov@sibext.com>" ).
-version( "0.1" ). % Do NOT set -vsn attribute! It is used to detect code changes by MD5-hashing the module's AST.

-import( xlib_dec, [ dec_to_int/1, dec_to_list/1 ] ).

-include( "eunit" ).

one_digit_to_int_test() ->

	0 = dec_to_int( << "0" >> ),
	1 = dec_to_int( << "1" >> ),
	2 = dec_to_int( << "2" >> ),
	3 = dec_to_int( << "3" >> ),
	4 = dec_to_int( << "4" >> ),
	5 = dec_to_int( << "5" >> ),
	6 = dec_to_int( << "6" >> ),
	7 = dec_to_int( << "7" >> ),
	8 = dec_to_int( << "8" >> ),
	9 = dec_to_int( << "9" >> )
.

two_digits_to_int_test() ->

	 0 = dec_to_int( << "00" >> ),
	
	 1 = dec_to_int( << "01" >> ),
	 9 = dec_to_int( << "09" >> ),
	
	19 = dec_to_int( << "19" >> ),
	91 = dec_to_int( << "91" >> ),
	
	10 = dec_to_int( << "10" >> ),
	90 = dec_to_int( << "90" >> ),
	
	99 = dec_to_int( << "99" >> )
.

two_digits_to_list_test() ->

	[  0 ] = dec_to_list( << "00" >> ),
	
	[  1 ] = dec_to_list( << "01" >> ),
	[  9 ] = dec_to_list( << "09" >> ),
	
	[ 19 ] = dec_to_list( << "19" >> ),
	[ 91 ] = dec_to_list( << "91" >> ),
	
	[ 10 ] = dec_to_list( << "10" >> ),
	[ 90 ] = dec_to_list( << "90" >> ),
	
	[ 99 ] = dec_to_list( << "99" >> )
.

eight_digits_to_list_test() ->

	[ 0, 1, 10, 99 ] = dec_to_list( << "00" "01" "10" "99" >> )
.

%EOF