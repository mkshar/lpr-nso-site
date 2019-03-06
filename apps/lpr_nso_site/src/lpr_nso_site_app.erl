-module( lpr_nso_site_app ).

-behaviour( application ).

%% Application callbacks
-export( [ start/2, stop/1 ] ).

-include( "lager" ).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start( Start_type, Start_args) ->

	lager:info( "start( ~p, ~p )", [ Start_type, Start_args ] ),

	Dispatch = cowboy_router:compile
	([
		{ '_', [
			{ "/", cowboy_static, { priv_file, lpr_nso_site, "index.html" } },
			{ "/members/[...]", cowboy_static, { priv_dir, lpr_nso_site, "members", [{mimetypes, {<<"text">>, <<"html">>, []}}] } },
			{ "/media/[...]",   cowboy_static, { priv_dir, lpr_nso_site, "media" } },
			{ "/apps/[...]",   cowboy_static, { priv_dir, lpr_nso_site, "apps" } },
			{ "/fonts/[...]",   cowboy_static, { priv_dir, lpr_nso_site, "fonts" } },
			{ "/logo/[...]",   cowboy_static, { priv_dir, lpr_nso_site, "logo" } },
			{ "/css/[...]",   cowboy_static, { priv_dir, lpr_nso_site, "css" } },
			{ "/library/[...]", cowboy_static, { priv_dir, lpr_nso_site, "library" } },
%			{ "/google_homeapp_webhook",    google_homeapp_webhook,    [] },
			{ "/websocket", lpr_nso_site_handler, [] },
			{ "/static/[...]", cowboy_static, { priv_dir, lpr_nso_site, "static" } }
		]}
	]),
	
	Redir = cowboy_router:compile
	([
		{ '_', [
			{ "/.well-known/[...]", cowboy_static, { priv_dir, lpr_nso_site, ".well-known" } }, %nso.libertarian-party.ru/.well-known/pki-validation/D9B3842C92942DEE765B981127A6C8F7.txt
			{ "/[...]", lpr_nso_site_redirector, [] }
			%{ '_', lpr_nso_site_redirector, [] }
		]}
	]),
	
	% UNIT_ENV :== staging | production | test | development

	Port =
		case os:getenv( "UNIT_PORT" ) of
			false  -> 8443;
			Result -> list_to_integer( Result )
		end,
	
	Libcat = filelib:is_regular( "/home/shar/.ssh/libcat.site.key" ),
	Sibext = filelib:is_regular( "/home/shar/.ssh/sibext.com.key" ),
	
	Conn_options =
		[
			{ cacertfile, "/home/shar/.ssh/nso.libertarian-party.ru.ca.crt" },
			{ certfile,   "/home/shar/.ssh/nso.libertarian-party.ru.crt"    },
			{ keyfile,    "/home/shar/.ssh/nso.libertarian-party.ru.key"    }
		],
		
	{ ok, _ } = cowboy:start_clear
	(
		http, %300,
		[{ port, 8080 }],
		#{ env => #{ dispatch => Redir } }
	),
	
	case Conn_options of
	
		[] ->

			lager:info( "starting plain HTTP:~p", [ Port ] ),
			{ ok, _ } = cowboy:start_clear
			(
				http, %300,
				[{ port, Port }],
				#{ env => #{ dispatch => Dispatch } }
			);
			
		_ ->
    
			lager:info( "starting TLS:~p( ~p )", [ Port, Conn_options ] ),
			{ ok, _ } = cowboy:start_tls
			(
				https, %300,
				lists:append( [ [{ port, Port }], Conn_options, [{ verify, verify_none }] ] ),
				%[ { env, [ { dispatch, Dispatch } ] } ]
				#{ env => #{ dispatch => Dispatch } }
			)
	end,
	
	lpr_nso_site_sup:start_link()
.

stop( State ) ->

	lager:info( "stop( ~p )", [ State ] ),
	
	ok
.

% EOF
