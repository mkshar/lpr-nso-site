-module( xlib_make ).

-export( [ make_and_test/2 ] ).

get_modules( Domains ) ->

	lists:flatten( get_modules( Domains, [] ) )
.

get_modules( [], A ) ->

	A
;

get_modules( [ Domain | Tail ], A ) ->

	Module = list_to_atom( atom_to_list( Domain ) ++ "_z_modules" ),
	Modules = Module:get_modules(),
	io:format( "Test domain: ~p, modules: ~p~n", [ Domain, Modules ] ),
	
	get_modules( Tail, [ Modules | A ] )
.

make_and_test( Mode, Domains ) ->
	
	case make:all( [ load, { d, Mode } ] ) of
	
		error ->
			error;
			
		_ ->
			eunit:test( [ get_modules( Domains ) ] ),
			ok
	end
.

% EOF
