%%%-------------------------------------------------------------------
%%% @author cwt  <woshi6ye@gmail.com>
%%% @copyright (C) 2017, <COMPANY>
%%% @doc  全局缓存行为模式
%%% @end
%%%-------------------------------------------------------------------
-module(kvs_behaviour).

-include("kvs.hrl").

-callback open(Name :: atom(), Options :: list()) ->
    {ok, Engine :: engine()} | {error, Reason :: any()}.

-callback close(Engine :: engine()) ->
    ok | {error, Reason :: any()}.

-callback destroy(Engine :: engine()) ->
    ok | {error, Reason :: any()}.

-callback contains(Engine :: engine(), Key :: term()) ->
    true | false.

-callback get(Engine :: engine(), Key :: term()) ->
    {ok, Value :: any()} | {error, Reason :: any()}.

-callback put(Engine :: engine(), Key :: term(), Value :: any()) ->
    ok | {error, Reason :: any()}.

-callback clear(Engine :: engine(), Key :: term()) ->
    ok | {error, Reason :: any()}.

-callback clear_all(Engine :: engine()) ->
    ok | {error, Reason :: any()}.

-callback is_empty(Engine :: engine()) ->
    boolean() | {error, term()}.

-callback persistence(Engine :: engine()) ->
  ok |  {error, Reason :: any()}.
