-module( lpr_nso_site ).
-author( "Mikhail Sharoglazov <sharoglazov@sibext.com>" ).
-version( "0.1" ). % Do NOT set -vsn attribute! It is used to detect code changes by MD5-hashing the module's AST.

-export( [ main/1 ] ). % API

-include( "lager" ).

main( Args ) ->

	lager:info( "main( ~p ).~n", [ Args ] ),
	
	{ Node_name, Rest_args } = case Args of
	
		[ "-sname", Short_name | T ] -> { Short_name, T };
		_ -> { "lpr_nso_site_server", Args }
	end,
	
	lager:debug( "Rest_args = ~p~n", [ Rest_args ] ),
	lager:debug( "net_kernel:start(...) returned ~p~n", [ net_kernel:start( [ list_to_atom( Node_name ), shortnames ] ) ] ),
	lager:debug( "node() returned ~p~n", [ node() ] ),
	
	%lager:start(),
	%ness_cloud_application:start()
	
	mad_repl:sh( Rest_args )
	
	
	%mad_repl:sh( [] )
.

% EOF
