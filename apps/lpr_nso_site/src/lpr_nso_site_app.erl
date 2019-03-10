-module( lpr_nso_site_app ).

-behaviour( application ).

%% Application callbacks
-export( [ start/2, stop/1 ] ).

-include( "lager" ).

get_env( Name, Default_value ) ->

	case os:getenv( Name ) of
		false -> Default_value;
		Value -> Value
	end
.

to_integer( Value ) ->

	if is_list( Value ) -> list_to_integer( Value ); true -> Value end
.

% localhost:8080

%% ===================================================================
%% Application callbacks
%% ===================================================================

start( Start_type, Start_args) ->

	lager:info( "start( ~p, ~p )", [ Start_type, Start_args ] ),

	Dispatch = cowboy_router:compile
	([
		{
			'_',
			[
				{ "/",              cowboy_static, { priv_file, lpr_nso_site, "index.html" } },
				%{ "/members/[...]", cowboy_static, { priv_dir, lpr_nso_site, "members", [{mimetypes, {<<"text">>, <<"html">>, []}}] } },
				{ "/media/[...]",   cowboy_static, { priv_dir,  lpr_nso_site, "media"      } },
				{ "/apps/[...]",    cowboy_static, { priv_dir,  lpr_nso_site, "apps"       } },
				{ "/fonts/[...]",   cowboy_static, { priv_dir,  lpr_nso_site, "fonts"      } },
				{ "/logo/[...]",    cowboy_static, { priv_dir,  lpr_nso_site, "logo"       } },
				{ "/css/[...]",     cowboy_static, { priv_dir,  lpr_nso_site, "css"        } },
				{ "/library/[...]", cowboy_static, { priv_dir,  lpr_nso_site, "library"    } },
				{ "/lib/[...]",     cowboy_static, { priv_dir,  lpr_nso_site, "lib"        } },
				{ "/static/[...]",  cowboy_static, { priv_dir,  lpr_nso_site, "static"     } }
			]
		}
	]),
	
	Domain = get_env( "DOMAIN", "nso.libertarian-party.ru" ),
	
	lager:info( "compiling redirector to HTTPS for ~p", [ Domain ] ),
	Redir = cowboy_router:compile
	([
		{
			'_',
			[ { "/[...]", lpr_nso_site_redirector, [ list_to_binary( Domain ) ] } ]
		}
	]),

	HTTP_port  = to_integer( get_env( "HTTP_PORT",  8080 ) ),
	HTTPS_port = to_integer( get_env( "HTTPS_PORT", 8443 ) ),
	
	Conn_options =
		[
			{ cacertfile, get_env( "CACERT_FILE", "/home/shar/.ssh/nso.libertarian-party.ru.ca.crt" ) },
			{ certfile,   get_env( "CERT_FILE",   "/home/shar/.ssh/nso.libertarian-party.ru.crt"    ) },
			{ keyfile,    get_env( "KEY_FILE",    "/home/shar/.ssh/nso.libertarian-party.ru.key"    ) }
		],
		
	lager:info( "starting HTTP: ~p", [ HTTP_port ] ),
	{ ok, _ } = cowboy:start_clear
	(
		http,
		[{ port, HTTP_port }],
		#{ env => #{ dispatch => Redir } }
	),
	
	lager:info( "starting HTTPS: ~p ( ~p )", [ HTTPS_port, Conn_options ] ),
	{ ok, _ } = cowboy:start_tls
	(
		https,
		lists:append( [ [{ port, HTTPS_port }], Conn_options, [{ verify, verify_none }] ] ),
		#{ env => #{ dispatch => Dispatch } }
	),
	
	lpr_nso_site_sup:start_link()
.

stop( State ) ->

	lager:info( "stop( ~p )", [ State ] ),
	
	ok
.

% EOF
