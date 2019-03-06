-module( lpr_nso_site_handler ).

-behaviour( cowboy_websocket_handler ).

-export( [ notify/2, notify/1 ] ).
-export( [ init/2 ] ).
-export
([
	websocket_init/1,
	websocket_handle/2,
	websocket_info/2,
	websocket_terminate/2
]).

-record( ws_state, { token, filter } ).

-include( "lager" ).

-define( WEBSOCKET_TIMEOUT, 5 * 60 * 1000 ). % ms, = 5 minutes
-define( PROTO_VERSION, <<"\"0.3.4\"">> ).
-define( VERSION_SPEC, { <<"version">>, { { json_utf8, ?PROTO_VERSION } } } ).

init( Req, Opts ) ->

	lager:debug( "init( ~p, ~p )", [ Req, Opts ] ),

	{ cowboy_websocket, Req, Opts, #{ idle_timeout => ?WEBSOCKET_TIMEOUT } } % Protocol Switch
.

notify( Message ) ->

	lager:debug( "notify( ~p )", [ Message ] )
.

notify( Token, Message ) ->

	lager:debug( "notify( ~p, ~p )", [ Token, Message ] )
.

websocket_init( State ) ->

	lager:debug( "websocket_init( ~p )", [ State ] ),

%	{ ok, State, ?WEBSOCKET_TIMEOUT }
	{ ok, #ws_state{} }
.

websocket_handle( { text, Msg } = Data, State ) ->

	lager:info( "websocket_handle( ~p, ~p )", [ Data, State ] ),
	{ ok, State }
;

websocket_handle( Data, State ) ->

	lager:debug( "websocket_init( ~p, ~p )", [ Data, State ] ),
	{ ok, State }
.

websocket_info( { response, Message } = Info, State ) ->

	lager:debug( "websocket_info( ~p, ~p )", [ Info, State ] ),
	{ reply, { text, Message }, State }
;

websocket_info( { log, Message } = Info, State ) ->

	lager:debug( "websocket_info( ~p, ~p )", [ Info, State ] ),
	{ ok, State }
;

websocket_info( { timeout, _Ref, Msg } = Info, State ) ->

	lager:debug( "websocket_info( ~p, ~p )", [ Info, State ] ),
	{ reply, { text, Msg }, State }
;


websocket_info( Info, State ) ->

	lager:debug( "websocket_info( ~p, ~p )", [ Info, State ] ),

	{ ok, State }
.

% TODO: delete?
websocket_terminate( Reason, State ) ->

	lager:debug( "websocket_terminate( ~p, ~p )", [ Reason, State ] ),

	ok
.

% EOF
