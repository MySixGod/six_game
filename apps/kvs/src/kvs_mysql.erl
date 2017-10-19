%%%-------------------------------------------------------------------
%%% @author cwt  <woshi6ye@gmail.com>
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 十月 2017 15:16
%%%-------------------------------------------------------------------
-module(kvs_mysql).
-behaviour(kvs_behaviour).
-author("cwt").

-include("kvs.hrl").

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

-import(kvs_util, [enc/3, dec/3, format_table_name/2]).

open(Name, Options) ->
  %% 获取参数
  Persistence = proplists:get_value(persistence, Options, false),
  KeyEncoding = proplists:get_value(key_encoding, Options, term),
  ValueEncoding = proplists:get_value(value_encoding, Options, term),
  EtsName = format_table_name(Name, ets),
  %% 初始化ets
  Ets = case Persistence of
          false -> ets:new(EtsName, [set, public, named_table]);
          _    -> DetsName = format_table_name(Name, dets),
            {ok, DetsRef} = dets:open_file(DetsName),
            EstTemp = ets:new(EtsName, [set, public, named_table]),
            dets:to_ets(DetsRef, EstTemp)
        end,
  %% 返回存储引擎
  {ok, #engine{
    name = Name,
    mod = ?MODULE,
    ref = Ets,
    key_enc = KeyEncoding,
    val_enc = ValueEncoding, options=Options}}.

%%  关闭
close(#engine{ref = Ref, name = Name}) ->
  persistence(#engine{ref = Ref, name = Name}),
  true = ets:delete(Ref),
  dets:close(format_table_name(Name, dets)),
  ok.

%%  数据完全删除
destroy(#engine{ref = Ref, name = Name}) ->
  true = ets:delete(Ref),
  catch dets:delete_all_objects(format_table_name(Name, dets)),
  ok.

contains(#engine{ref = Ref}, Key) ->
  ets:member(Ref, Key).

get(#engine{ref = Ref, key_enc = Ke, val_enc = Ve}, Key) ->
  case ets:lookup(Ref, enc(key, Key, Ke)) of
    []           -> {error, not_found};
    [{_, Value}] -> dec(value, Value, Ve)
  end.

%% @doc If there already exists an object with a key matching the key of the given object,
%% the old object will be replaced.
put(#engine{ref = Ref, key_enc = Ke, val_enc = Ve}, Key, Value) ->
  true = ets:insert(Ref, {enc(key, Key, Ke), enc(value, Value, Ve)}),
  ok.

clear(#engine{ref = Ref, key_enc = Ke}, Key) ->
  true = ets:delete(Ref, enc(key, Key, Ke)),
  ok.

clear_all(#engine{ref = Ref}) ->
  true = ets:delete_all_objects(Ref),
  ok.

is_empty(#engine{ref = Ref}) ->
  case ets:info(Ref, size) of
    undefined  -> true;
    Size       -> Size =:= 0
  end.

persistence(#engine{ref = Ref, name = Name}) ->
  {ok, Dets} = dets:open_file(format_table_name(Name, dets), []),
  dets:delete_all_objects(Dets),
  ets:to_dets(Ref, Dets).


