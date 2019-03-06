-module( xlib_binary ).
-author( "Mikhail Sharoglazov <sharoglazov@sibext.com>" ).
-version( "0.1" ). % Do NOT set -vsn attribute! It is used to detect code changes by MD5-hashing the module's AST.

-export( [ bxor_binaries/2 ] ).

-include( "eunit" ).

%
% by Chandrashekhar Mullaparthi, see http://erlang.org/pipermail/erlang-questions/2003-February/007507.html
%
% fixed by m.shar
%
bxor_binaries( Bin_1, Bin_2 ) ->
	
	Sz_1 = byte_size( Bin_1 ) * 8,
	Sz_2 = byte_size( Bin_2 ) * 8,
	
	<< Int_1 : Sz_1 /little-integer >> = Bin_1,
	<< Int_2 : Sz_2 /little-integer >> = Bin_2,
	
	Res = Int_1 bxor Int_2,
	
	Max_size = max( Sz_1, Sz_2 ),
	
	<< Res : Max_size /little-integer >>
.

% EOF
