-module( lpr_nso_site_redirector ).

%-export( [ init/2, init/3, handle/2, terminate/2 ] ).
-export( [ init/2, terminate/3 ] ).

-include( "lager" ).

%init( Req, Opts ) ->
%
%	lager:info( "start( ~p, ~p )", [ Req, Opts ] ),
%
%	%URI = cowboy_req:uri( Req, #{ port => 443 } ),
%	Req_updated = cowboy_req:reply( 301, #{ <<"location">> => <<"https://libcat.site">> }, Req ),
%	lager:info( "Req_updated: ~p", [ Req_updated ] ),
%	{ halt, Req_updated, Opts }
%.

%start(
%	#{
%		bindings => #{},
%		body_length => 0,
%		cert => undefined,
%		has_body => false,
%		headers =>
%		#{
%			<<"accept">>
%				=> <<"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8">>,
%			<<"accept-encoding">>
%				=> <<"gzip, deflate">>,
%			<<"accept-language">>
%				=> <<"en-US,en;q=0.5">>,
%			<<"cache-control">>
%				=> <<"no-cache">>,
%			<<"connection">>
%				=> <<"keep-alive">>,
%			<<"cookie">>
%				=> <<"_ym_uid=1538476817978999275; _ym_d=1538476817; __utma=237409437.289309478.1538476817.1538915211.1539039039.8; __utmc=237409437; __utmz=237409437.1538585464.6.3.utmcsr=away.vk.com|utmccn=(referral)|utmcmd=referral|utmcct=/away.php; _ym_isad=1">>,
%			<<"host">>
%				=> <<"nso.libertarian-party.ru">>,
%			<<"pragma">>
%				=> <<"no-cache">>,
%			<<"upgrade-insecure-requests">> => <<"1">>,
%			<<"user-agent">> => <<"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:57.0) Gecko/20100101 Firefox/57.0">>},
%			host => <<"nso.libertarian-party.ru">>,
%			host_info => undefined,
%			method => <<"GET">>,
%			path => <<"/members/54180123">>,
%			path_info => [<<"members">>,<<"54180123">>],
%			peer => {{87,103,252,48},35178},
%			pid => <0.1584.0>,
%			port => 80,
%			qs => <<>>,
%			ref => http,
%			scheme => <<"http">>,
%			sock => {{192,168,1,11},8080},
%			streamid => 1,
%			version => 'HTTP/1.1'
%	},
%	[]
%)




init( Req, Opts ) ->

	lager:info( "start( ~p, ~p )", [ Req, Opts ] ),
	%Req_updated = cowboy_req:reply( 301, #{ <<"location">> => <<"https://libcat.site">> }, Req ),
%	#{ headers := Headers } = Req,
%	lager:info( "Headers: ~p", [ Headers ] ),
	#{ path := Path } = Req,
	lager:info( "Path: ~p", [ Path ] ),
	Resp = cowboy_req:reply( 301, #{ <<"location">> => <<"https://nso.libertarian-party.ru", Path /binary >> }, Req ),
	
	lager:info( "Resp: ~p", [ Resp ] ),
	{ ok, Resp, Opts }
.

%init({tcp, http}, Req, _Opts) ->
%    {ok, Req, undefined_state}.
%
%handle(Req, State) ->
%    {ok, Reply} = cowboy_http_req:reply(
%        302,
%        [{<<"Location">>, <<"http://www.google.com">>}],
%        <<"Redirecting with Header!">>,
%        Req
%    ),
%    {ok, Reply, State}.

terminate( Reason, Req, State ) ->

	lager:info( "terminate( ~p, ~p, ~p )", [ Reason, Req, State ] ),
	ok
.
