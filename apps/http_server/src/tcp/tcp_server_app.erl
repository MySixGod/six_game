%%%-------------------------------------------------------------------
%%% @author cwt  <woshi6ye@gmail.com>
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 八月 2017 10:56
%%%-------------------------------------------------------------------
-module(tcp_server_app).
-behaviour(application).
-export([start/2, stop/1]).
-define(PORT,  2222).

start(_Type, _Args) ->
  io:format("tcp app start~n"),
  case tcp_server_sup:start_link(?PORT) of
    {ok, Pid} ->
      {ok, Pid};
    Other ->
      {error, Other}
  end.

stop(_S) ->
  ok.