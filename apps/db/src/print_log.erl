%%%-------------------------------------------------------------------
%%% @author cwt  <woshi6ye@gmail.com>
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%     erlang 打印中文
%%% @end
%%% Created : 19. 十月 2017 17:07
%%%-------------------------------------------------------------------
-module(print_log).

-compile(export_all).
-export([log/2,
  test/0]).

log(Format, Data)->
  L = get_format_list(Format),
  DataList=
    lists:map(
      fun({1, X}) ->
        unicode:characters_to_binary(X);
        ({0, X}) ->
          X
      end, lists:zip(L, Data)),
  io:format(Format,DataList).


get_format_list(Format) ->
  get_format_list(Format, []).
get_format_list([], Acc) ->
  Acc;
get_format_list([$~|L], Acc) ->
  case L of
    "ts" ++ Other ->
      get_format_list(Other, Acc ++ [1]);
    "n" ++ Other ->
      get_format_list(Other, Acc);
    _ ->
      get_format_list(L, Acc ++ [0])
  end;
get_format_list([_H|L],Acc) ->
  get_format_list(L, Acc).


test()->
  log("test===~ts",["你好"]).
