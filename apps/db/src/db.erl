%%%-------------------------------------------------------------------
%%% @author cwt  <woshi6ye@gmail.com>
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%   db常用操作
%%% @end
%%% Created : 21. 九月 2017 11:01
%%%-------------------------------------------------------------------
-module(db).


-define(DEFAULT_POOL, six_game).

-define(PRINT(Term), io:format("~p ~n", [Term])).

-define(DEFAULT_TIMEOUT, 1000).

-compile(export_all).

term_to_bit_string(Term) ->
  list_to_bitstring(io_lib:format("~w", [Term])).

bit_string_to_term(Term) ->
  string_to_term(binary_to_list(Term)).

string_to_term(String) ->
  case erl_scan:string(String ++ ".") of
    {ok, Tokens, _} ->
      case erl_parse:parse_term(Tokens) of
        {ok, Term} -> Term;
        _ -> undefined
      end;
    _ -> undefined
  end.


%% ==============================================================================
%%                                query
%% ==============================================================================
%% 单个查询
query_one(Sql) ->
  case catch mysql_poolboy:query(?DEFAULT_POOL, Sql, ?DEFAULT_TIMEOUT) of
    {ok, _, [[BitValue]]} -> {ok, bit_string_to_term(BitValue)};
    {error, Error} -> ?PRINT(Error);
    _ -> error
  end.

%% 多个查询
query_all(Sql) ->
  case catch mysql_poolboy:query(?DEFAULT_POOL, Sql, ?DEFAULT_TIMEOUT) of
    {ok, _, List} ->
      {ok, lists:map(fun(ListInner) -> [bit_string_to_term(X) || X <- ListInner] end, List)};
    {error, Error} -> ?PRINT(Error);
    _ -> error
  end.


%% ==============================================================================
%%                                insert
%% ==============================================================================
insert(Sql, Param) ->
  execute(Sql, Param).


%% ==============================================================================
%%                                delete
%% ==============================================================================
delete(Sql, Param) ->
  execute(Sql, Param).

%% ==============================================================================
%%                                update
%% ==============================================================================
update(Sql, Param) ->
  execute(Sql, Param).


%% ==============================================================================
%%                                execute
%% ==============================================================================
execute(Sql, Param) ->
  case catch mysql_poolboy:query(?DEFAULT_POOL, Sql, Param, ?DEFAULT_TIMEOUT) of
    {ok, _, List} ->
      lists:map(fun(ListInner) -> [bit_string_to_term(X) || X <- ListInner] end, List);
    {error, Error} -> ?PRINT(Error);
    Error -> ?PRINT(Error)
  end.



%% ==============================================================================
%%                                transaction
%% ==============================================================================
transaction(Fun) ->
  case catch mysql_poolboy:transaction(?DEFAULT_POOL, Fun) of
    ok -> ok;
    {error, Error} -> ?PRINT(Error);
    Error -> ?PRINT(Error)
  end.


%% ==============================================================================
%%                                test
%% ==============================================================================

t() ->
  ?PRINT("hello world"),
  ?PRINT("test successaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa").


%%  单个查询
t1() ->
  query_one("select password from login where account = 'cwt' ").

%%  多个查询
t2() ->
  query_all("select * from login").

t3() ->
  Sql = "insert into login (account, password) values(?, ?)",
  Param = ["t3", "t3"],
  execute(Sql, Param).

t4() ->
  Sql = "update login set password = ? where account = ?",
  Param = ["t4", "t3"],
  execute(Sql, Param).


t6() ->
  Fun = fun(_) ->
    Sql = "select ? from login",
    Param = ["account"],
    execute(Sql, Param) end,
  transaction(Fun).


t7() ->
  <<1, 0, 1, 6,  (binary:decode_unsigned(<<"Mark_h">>)):6/unit:8,
    (binary:decode_unsigned(<<"password">>)):256, "">>.


%% 从n个数里面取m个数的组合
-spec get_random_num(integer()) -> integer().
get_random_num(Max) ->
  <<A:32, B:32, C:32>> = crypto:rand_bytes(12),
  rand:seed({A,B,C}),
  rand:uniform(Max).




