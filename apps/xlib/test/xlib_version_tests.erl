-module( xlib_version_tests ).

-vsn( 113813660015585331061986042122236339798 ). % Realistic "MD5 version" for test purposes.
-version( "0.1" ). % Human-readable version string.

-include( "eunit" ).

-import( xlib_version, [ get_module_version/1 ] ).

get_module_version_test() ->
	
	{ Readable, MD5_hash } = get_module_version( xlib_version_tests ),

	Readable = "0.1",
	MD5_hash = 113813660015585331061986042122236339798,
	
	ok
.

% EOF
