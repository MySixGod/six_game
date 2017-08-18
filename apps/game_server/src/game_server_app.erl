%%%-------------------------------------------------------------------
%% @doc game_server public API
%% @end
%%%-------------------------------------------------------------------

-module(game_server_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
%%    db  apps
    application:start(mysql),
    application:start(poolboy),
    application:start(mysql_poolboy),

    game_server_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
