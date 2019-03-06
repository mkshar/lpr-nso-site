-module( lpr_nso_site_sup ).

-behaviour( supervisor ).

%% API
-export( [ start_link/0 ] ).

%% Supervisor callbacks
-export( [ init/1 ] ).

-include( "lager" ).

%% Helper macro for declaring children of supervisor
%-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->

	lager:info( "start_link()", [] ),

	supervisor:start_link( { local, ?MODULE }, ?MODULE, [] )
.

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init( [] ) ->

	lager:info( "init( [] )", [] ),

	{ ok, { { one_for_one, 5, 10 }, [] } }
.

