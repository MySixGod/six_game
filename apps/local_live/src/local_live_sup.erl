%%%-------------------------------------------------------------------
%% @doc local_live top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(local_live_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).


init([tcp_client_sup]) ->
    io:format("tcp sup init client~n"),
    {ok,
        { {simple_one_for_one, 0, 1},
            [
                { tcp_server_handler,
                    {tcp_server_handler, start_link, []},
                    temporary,
                    brutal_kill,
                    worker,
                    [tcp_server_handler]
                }
            ]
        }
    };

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    {ok,
        { {one_for_one, 5, 60},
            [
                % client supervisor
                { tcp_client_sup,
                    {supervisor, start_link, [{local, tcp_client_sup}, ?MODULE, [tcp_client_sup]] },
                    permanent,
                    2000,
                    supervisor,
                    [tcp_server_listener]
                },
                % tcp listener
                { tcp_server_listener,
                    {tcp_server_listener, start_link, []},
                    permanent,
                    2000,
                    worker,
                    [tcp_server_listener]
                }
            ]
        }
    }.


%%====================================================================
%% Internal functions
%%====================================================================
