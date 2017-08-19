%%%-------------------------------------------------------------------
%%% @author cwt  <woshi6ye@gmail.com>
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 八月 2017 11:35
%%%-------------------------------------------------------------------
-module(test).
-author("cwt").

-include_lib("eunit/include/eunit.hrl").

%% API
-compile(export_all).

tcp_test() ->
  {ok, Socket} = gen_tcp:connect({127,0,0,1}, 2222, [{packet, 0}]),
  gen_tcp:send(Socket, <<"hello">>).
