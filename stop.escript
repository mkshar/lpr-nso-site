#!/usr/bin/env escript
%% -*- erlang -*-
%%!+pc unicode -noshell -name ness_server_stopper@127.0.0.1 -s init stop
%%
%% -detached
%%-----------------------------------------------------------------------

main( _ ) ->
	
	{ ok, Hostname } = inet:gethostname(),
	io:format( "Hostname: ~p~n", [ Hostname ] ),
%	Nodename = "ness_server@" ++ Hostname,
	Nodename = "ness_server@127.0.0.1",
	io:format( "Server's Nodename: ~p~n", [ Nodename ] ),
	Res = rpc:call( list_to_atom( Nodename ), init, stop, [] ),
	io:format( "RPC call result: ~p~n", [ Res ] )
.
