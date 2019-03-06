-module( test ).

-export( [ server/0, server/1, client/0, client/1, client/2, listen/2 ] ).

log( State, Format, Params ) ->

	{ Step, Connections, Timeouts, Invalids, Unexpected } = State,
	
	io:format( "~p: C=~p/T=~p/I=~p/U=~p: ", [ Step, Connections, Timeouts, Invalids, Unexpected ] ),
%	io:format( "~p: ", [ State ] ),
	io:format( Format, Params ),
	io:format( "~n", [] )	

%	io:format
%	(
%		lists:concat( [ "~p/~p/~p/~p/~p: ", Format, "~n" ] ),
%		lists:concat( [ Step, Connections, Timeouts, Invalids, Unexpected, Params ] )
%	)
.

client() -> client( wifi, 1 ).

client( wifi  ) -> client( wifi,  1    );
client( eth   ) -> client( eth,   1    );
client( local ) -> client( local, 1    );
client( User  ) -> client( wifi,  User ).

client( wifi, User ) ->

	client
	(
		{ 192, 168,  16, 254 }, % Mezzo WiFi AP
		User
	)
;

client( eth, User ) ->

	client
	(
		{ 192, 168,   1,  91 }, % Mezzo WiFi AP
		User
	)
;

client( local, User ) ->

	client
	(
		{ 127, 0, 0, 1 }, % localhost: use simulator
		User
	)
;

client( Server_addr, User ) ->

	Request =
		case User of
			1 -> <<"83010665P1410E08?\r\n">>;
			2 -> <<"83020665P1410E07?\r\n">>;
			3 -> <<"83030665P1410E06?\r\n">>;
			4 -> <<"83040665P1410E05?\r\n">>;
			5 -> <<"83040665P1410E05?\r\n">>
		end,
	
	loop_client( undefined, Server_addr, { 0, 0, 0, 0, 0 }, Request )
.

loop_client( Socket_0, Server_addr, { Step_0, Connections_0, Timeouts_0, Invalid_0, Unexpected_0 }, Request ) ->

	State_0 = { Step_0, Connections_0, Timeouts_0, Invalid_0, Unexpected_0 },

	{ Socket, Connections } =
		case Socket_0 of
			undefined ->
				log( State_0, "[RE]CONNECTING to ~p:~p", [ Server_addr, 9469 ] ),
				{ ok, Socket_tmp } = gen_tcp:connect( Server_addr, 9469, [ binary, { active, true } ] ), % { error, etimedout } ->
				gen_tcp:send( Socket_tmp, <<"83010E67P1410EBedroomEEA?\r\n">> ),
				{ Socket_tmp, Connections_0 + 1 };
			_ ->
				{ Socket_0,   Connections_0 }
		end,

	Step  = Step_0 + 1,
	State = { Step, Connections, Timeouts_0, Invalid_0, Unexpected_0 },
	
	log( State, "TX: ~p", [ Request ] ),
	gen_tcp:send( Socket, Request ),
	
	{ Action, Timeouts, Invalid, Unexpected } =
		receive
			{ tcp, _Port, Response } ->
			
				log( State, "RX: ~p", [ Response ] ),
				case contains_zero( Response ) of
					true  ->
						log( State_0, "INVALID PACKET: ~p", [ Response ] ),
						{ proceed, Timeouts_0, Invalid_0 + 1, Unexpected_0 };
					false ->
						{ proceed, Timeouts_0, Invalid_0, Unexpected_0 }
				end;
				
			{ tcp_closed, _Port } ->
			
				log( State, "CLOSED", [] ),
				{ reconnect, Timeouts_0, Invalid_0, Unexpected_0 };
				
			Unexpected_msg ->
			
				log( State, "UNEXPECTED: ~p", [ Unexpected_msg ] ),
				{ proceed, Timeouts_0, Invalid_0, Unexpected_0 + 1 }
			
			after 5000 ->
			
				log( State, "TIMED OUT", [] ),
				{ proceed, Timeouts_0 + 1, Invalid_0, Unexpected_0 + 1 }
		end,
		
	receive after 100 -> ok end,
	
	Socket_X = case Action of proceed -> Socket; reconnect -> undefined end,
	State_X  = { Step, Connections, Timeouts, Invalid, Unexpected },
	
	loop_client( Socket_X, Server_addr, State_X, Request )
.

contains_zero( <<>> ) -> false;
contains_zero( << 0: 8 /integer, _Rest/binary >> ) -> true;
contains_zero( << _: 8 /integer,  Rest/binary >> ) -> contains_zero( << Rest/binary >> ).



server() ->
	
	server( 9469, 0 )
.

server( Invalid_packet ) ->
	
	server( 9469, Invalid_packet )
.

server( Port, Invalid_packet ) ->

	Pid = spawn_link( ?MODULE, listen, [ Port, Invalid_packet ] ),
	{ ok, Pid }
.

listen( Port, Invalid_packet ) ->

	io:format( "Opening port ~p...~n", [ Port ] ),
	{ ok, Server_socket } = gen_tcp:listen( Port, [ { active, true }, binary, { reuseaddr, true } ] ),

	accept( Server_socket, Invalid_packet ),
	timer:sleep( infinity )
.

accept( Server_socket, Invalid_packet ) ->

	io:format( "Waiting for incoming connection on ~p...~n", [ Server_socket ] ),
	{ ok, Client_socket } = gen_tcp:accept( Server_socket ),
	{ ok, { Client_addr, Client_port } } = inet:peername( Client_socket ),
	io:format( "Accepted ~p:~p~n", [ Client_addr, Client_port ] ),
	
	spawn( fun() -> accept( Server_socket, Invalid_packet ) end ),
	
	loop_server( echo, Client_socket, Client_addr, Client_port, 0, Invalid_packet )
.

loop_server( disconnect, Client_socket, Client_addr, Client_port, Step, _Invalid_packet ) ->

	gen_tcp:close( Client_socket ),
	io:format( "~p: [~p:~p]: CLOSING~n", [ Step, Client_addr, Client_port ] ),
	ok
;

loop_server( echo, Client_socket, Client_addr, Client_port, Step, Invalid_packet ) ->

	Phase =
		receive
			{ tcp, Client_socket, Packet } ->
		
				io:format( "~p: [~p:~p] C->S: ~p~n", [ Step, Client_addr, Client_port, Packet ] ),
				
				receive after 100 -> ok end, % delay 100 ms
				
				Tail =
					case Invalid_packet of
						0 -> <<>>;
						_ -> case Step rem Invalid_packet of 0 -> <<0>>; _-> <<>> end % every N-th packet contains zero
					end,
					
				gen_tcp:send( Client_socket, << Packet /binary, Tail /binary >> ),
				
				echo;
			
			{ tcp_closed, _Socket } ->
			
				io:format( "~p: [~p:~p] Socket closed.~n", [ Step, Client_addr, Client_port ] ),
				
				disconnect
		end,
		
	loop_server( Phase, Client_socket, Client_addr, Client_port, Step + 1, Invalid_packet )
.

% EOF

