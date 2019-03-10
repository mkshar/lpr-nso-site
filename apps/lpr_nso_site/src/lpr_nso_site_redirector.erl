-module( lpr_nso_site_redirector ).
-export( [ init/2, terminate/3 ] ).
-include( "lager" ).

init( Req, [ Redir_domain ] = Opts ) ->

	%lager:info( "start( ~p, ~p )", [ Req, Opts ] ),
	#{ path := Path } = Req,
	lager:info( "redir: path = ~p", [ Path ] ),
	#{ qs := QS } = Req,
	%lager:info( "QS: ~p", [ QS ] ),
	
	Domain = if ( QS == <<"redirect=local">> ) -> <<"localhost">>; true -> Redir_domain end,
	
	Resp = cowboy_req:reply( 301, #{ <<"location">> => << "https://", Domain /binary, Path /binary >> }, Req ),
	%lager:info( "Resp: ~p", [ Resp ] ),
	{ ok, Resp, Opts }
.

terminate( Reason, Req, State ) ->

	%lager:info( "terminate( ~p, ~p, ~p )", [ Reason, Req, State ] ),
	ok
.
