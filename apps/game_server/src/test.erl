%%%-------------------------------------------------------------------
%%% @author cwt  <woshi6ye@gmail.com>
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 八月 2017 12:27
%%%-------------------------------------------------------------------
-module(test).
-author("cwt").

%% API
-compile(export_all).

t1() ->
  application:start(game_server),
  mysql_poolboy:query(pool1, "SELECT * FROM hello_table").