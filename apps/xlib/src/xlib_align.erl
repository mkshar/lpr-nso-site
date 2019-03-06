-module( xlib_align ).
-author( "Mikhail Sharoglazov <sharoglazov@sibext.com>" ).
-version( "0.1" ). % Do NOT set -vsn attribute! It is used to detect code changes by MD5-hashing the module's AST.

-export( [ padding_size/2, align/2, align/3 ] ).

-include( "eunit" ).

padding_size( Data_length, Block_size ) ->
	
	( Block_size - ( Data_length rem Block_size ) ) rem Block_size
.

align( Data, Block_size ) ->

	align
	(
		Data,
		Block_size,
		fun( Padding_size ) ->
			list_to_binary( lists:duplicate( Padding_size, 0 ) )
		end
	)
.

align( Data, Block_size, Generator ) ->
	
	Padding_size = padding_size( byte_size( Data ), Block_size ),
	Padding = Generator( Padding_size ),
	
	<< Data /binary, Padding /binary >>
.

% EOF
