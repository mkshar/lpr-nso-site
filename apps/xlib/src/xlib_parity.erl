-module( xlib_parity ).
-author( "Mikhail Sharoglazov <sharoglazov@sibext.com>" ).
-version( "0.1" ). % Do NOT set -vsn attribute! It is used to detect code changes by MD5-hashing the module's AST.

-export( [ set_parity/1 ] ).

-include( "eunit" ).

%
% (o) http://blog.listincomprehension.com/2010/10/setting-parity-on-des-keys.html
%
% Thanks to Michael Santos.
%

% Uses a binary comprehension to read 1 byte at a time from the 8 byte key.
set_parity( Bin ) ->
	
	<< << ( check_parity( N ) ) >> || << N >> <= Bin >>
.

% Checks whether an integer has an odd or even parity and returns the integer XOR'ed with 1 if the parity is even.
check_parity( N ) ->
	
	case odd_parity( N ) of
		true  -> N;
		false -> N bxor 1
	end
.

% Counts the bit set by using a bit comprehension to return the list of bits that are set. The modulus of the length of this list returns oddness/evenness.
odd_parity( N ) ->

	Set = length( [ 1 || << 1 : 1 >> <= << N >> ] ),
	Set rem 2 == 1
.

% EOF
