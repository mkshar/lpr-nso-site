-module( xlib_version ).
-author( "Mikhail Sharoglazov <sharoglazov@sibext.com>" ).
-version( "0.1" ). % Do NOT set -vsn attribute! It is used to detect code changes by MD5-hashing the module's AST.

-export( [ get_module_version/1, get_module_compile_time/1 ] ).

-include( "eunit" ).

get_module_version( Mod ) ->
	
	Mod_attrs = proplists:get_value( attributes, Mod:module_info() ),
	Readable = proplists:get_value( version, Mod_attrs ),
	[ MD5_hash | _ ] = proplists:get_value( vsn, Mod_attrs ),

	{ Readable, MD5_hash }
.

get_module_compile_time( Mod ) ->

	Mod_compile_info = proplists:get_value( compile, Mod:module_info() ),
	{ Year, Month, Day, Hour, Min, Sec } = proplists:get_value( time, Mod_compile_info ),

	{ { Year, Month, Day }, { Hour, Min, Sec } }
.

% EOF
