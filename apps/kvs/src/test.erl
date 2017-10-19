%%%-------------------------------------------------------------------
%%% @author cwt  <woshi6ye@gmail.com>
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 八月 2017 15:11
%%%-------------------------------------------------------------------
-module(test).

-include("kvs.hrl").

%% API
-compile(export_all).

%%  fun匹配不同的参数

t1() ->
  Name = test,
  {ok, Engine} = kvs:open(Name, [{backend, kvs_ets}]),
  Key = <<"aa">>,
  Value = [1,2, "hello"],
  ok =  kvs:put(Engine, Key, Value),
  erlang:display({value, kvs:get(Engine, Key)}).

t2() ->
  Name = test,
  {ok, Engine} = kvs:open(Name, [{backend, kvs_ets}, {persistence, true}]),
  Key = <<"aa">>,
  Value = kvs:get(Engine, Key),
  erlang:display(Value).

t3() ->
  A = [a | b],
  lists:map(fun(V) -> erlang:display(V) end, A).

t4([A,B]) ->
  erlang:display({A, B}).

compile(String) ->
  [ParseTree] = element(2,
    erl_parse:parse_exprs(
      element(2,
        erl_scan:string(String)))),
  generate_code(ParseTree).
generate_code({op, _Line, '+', Arg1, Arg2}) ->
  generate_code(Arg1) ++ generate_code(Arg2) ++ [add];
generate_code({op, _Line, '*', Arg1, Arg2}) ->
generate_code(Arg1) ++ generate_code(Arg2) ++ [multiply];
generate_code({integer, _Line, I}) -> [push, I].


interpret(Code) -> interpret(Code, []).
interpret([push, I |Rest], Stack) -> interpret(Rest, [I|Stack]);
interpret([add |Rest], [Arg2, Arg1|Stack]) -> interpret(Rest, [Arg1+Arg2|Stack]);
interpret([multiply|Rest], [Arg2, Arg1|Stack]) -> interpret(Rest, [Arg1 * Arg2|Stack]);
interpret([], [Res|_]) -> Res.

sort([]) -> [];
sort([Head | List]) ->
  sort([X || X <- List, X < Head]) ++ sort([X || X <- List, X >= Head]).


t10() ->
  io:format("PID BINARY: ~p~n", [term_to_binary(self())]),
  io:format("size1: ~p~n", [size(term_to_binary(self()))]).


t11([A| _]) ->
  io:format("A: ~p~n", [A]).

e1() ->
  case catch e2() of
    ERROR -> erlang:display(ERROR)
  end.

e2() ->
  e3().

e3() ->
  throw({error, e3}).

t12() ->
  io:format("~p ~n", [?make(nihao)]).


t13() ->
  [].


