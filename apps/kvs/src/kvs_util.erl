%%%-------------------------------------------------------------------
%%% @author cwt  <woshi6ye@gmail.com>
%%% @copyright (C) 2017, <COMPANY>
%%% @doc  缓存工具方法
%%% @end
%%%-------------------------------------------------------------------
-module(kvs_util).

-include("kvs.hrl").

-export([enc/3, dec/3, format_table_name/2]).

enc(_, V, raw) -> V;
enc(_, V, term) -> term_to_binary(V);
enc(_, V, {term, Opts}) -> term_to_binary(V, Opts);
enc(T, V, E) -> erlang:error({cannot_encode, [T, V, E]}).

dec(_, V, raw) -> V;
dec(_, V, term) -> binary_to_term(V);
dec(_, V, {term, _}) -> binary_to_term(V);
dec(T, V, E) -> erlang:error({cannot_decode, [T, V, E]}).


format_table_name(Name, kvs) ->
  list_to_atom(atom_to_list(Name) ++ "_kvs");
format_table_name(Name, _) ->
  list_to_atom(atom_to_list(Name) ++ "_kvs").


