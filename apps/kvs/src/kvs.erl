%%%-------------------------------------------------------------------
%%% @author cwt  <woshi6ye@gmail.com>
%%% @copyright (C) 2017, <COMPANY>
%%% @doc  ets全局缓存，默认使用term_to_binary的方式解码编码
%%%       1.不仅速度更快，而且更加节省内存
%%% @end
%%%-------------------------------------------------------------------
-module(kvs).

-export([open/2,
         close/1,
         destroy/1,
         contains/2,
         get/2,
         put/3,
         clear/2,
         clear_all/1,
         is_empty/1,
         persistence/1]).

-include("kvs.hrl").

-type key() ::  term().
-type value() :: term().
%%  指定使用哪个mod进行存储,以后可以加上 kvs_mysql
-type backend() :: kvs_ets.
-type encode() :: term | raw | {term, [compressed | {compressed, Level :: 0..9} | {minor_version, Version :: 0..1}]}.
-type options() :: {backend, backend()} | {persistence, atom()} | {key_encoding, encode()} | {value_encoding, encode()}.

%%  开启一个缓存
-spec open(Name :: atom(), Options :: options()) ->
    {ok, engine()} | {error, any()}.
open(Name, Options) ->
    %%  默认使用ets进行缓存，
    Mod = proplists:get_value(backend, Options, kvs_ets),
    Mod:open(Name, Options).

%% 关闭缓存，缓存清空，保留实例化数据
-spec close(engine()) -> ok | {error, any()}.
close(#engine{mod = Mod} = Engine) ->
    Mod:close(Engine).

%% 完全删除
-spec destroy(engine()) -> ok | {error, any()}.
destroy(#engine{mod = Mod} = Engine) ->
    Mod:destroy(Engine).

%% 是否包含某个key
-spec contains(engine(), key()) -> true | false.
contains(#engine{mod = Mod} = Engine, Key) ->
    Mod:contains(Engine, Key).

%% get
-spec get(engine(), key()) -> any() | {error, term()}.
get(#engine{mod = Mod} = Engine, Key) ->
    Mod:get(Engine, Key).

%% put
-spec put(engine(), key(), value()) -> ok | {error, term()}.
put(#engine{mod = Mod} = Engine, Key, Value) ->
    Mod:put(Engine, Key, Value).

%% 清理缓存数据
-spec clear(engine(), key()) -> ok | {error, term()}.
clear(#engine{mod = Mod} = Engine, Key) ->
    Mod:clear(Engine, Key).

-spec clear_all(engine()) -> ok | {error, term()}.
clear_all(#engine{mod = Mod} = Engine) ->
  Mod:clear_all(Engine).

%% 缓存是否为空
-spec is_empty(engine()) -> boolean() | {error, term()}.
is_empty(#engine{mod = Mod} = Engine) ->
    Mod:is_empty(Engine).

%% @doc  data persistence
-spec persistence(engine()) -> ok | {error, term()}.
persistence(#engine{mod = Mod} = Engine) ->
  Mod:persistence(Engine).