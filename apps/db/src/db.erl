%%%-------------------------------------------------------------------
%%% @author cwt  <woshi6ye@gmail.com>
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 九月 2017 11:01
%%%-------------------------------------------------------------------
-module(db).

-define(DEFAULT_POOL, six_game).

-define(DEFAULT_TIMEOUT, 1000).

-compile(export_all).

get_one(Sql) ->
  mysql_poolboy:query(?DEFAULT_POOL, Sql, ?DEFAULT_TIMEOUT).


t1() ->
  get_one("select account from login").

