-module(record_read).
-export([readlines/1, get_items/1, get_entries/1, get_couchdb_format/1]).

readlines(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    get_all_lines(Device, []).

get_all_lines(Device, Accum) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device), lists:reverse(Accum);
        Line -> get_all_lines(Device, [Line|Accum])
    end.

%% code:add_patha("/Users/ppiwonka/Desktop/prog/erlang/couchbeam/ebin").
%% application:start(crypto).
%% application:start(couchbeam).
%% couchbeam:open_connection({"wnka", {"127.0.0.1", 5984}}).
%% Lines=record_read:readlines("/Users/ppiwonka/Desktop/prog/erlang/vinyl.txt").
%% Items = record_read:get_items(Lines).
%% Records = record_read:get_entries(Items).
%% Couch = record_read:get_couchdb_format(Records).
%% lists:map(fun(X) -> couchbeam:save_doc(wnka, "vinyl", X) end, Couch).

get_items(Lines) ->
    lists:map(fun(X) -> string:tokens(X, "|") end, Lines).

get_entries(Items) ->
    lists:map(fun(X) ->
                      Xt = list_to_tuple(X),
                      {{"artist", list_to_binary(string:strip(element(1, Xt)))}, 
                       {"album", list_to_binary(string:strip(element(2, Xt)))},
                       {"year", list_to_binary(string:strip(element(3, Xt)))},
                       {"format", list_to_binary(string:strip(element(4, Xt)))},
                       {"label", list_to_binary(string:strip(element(5, Xt)))},
                       {"catalog", list_to_binary(string:strip(element(6, Xt)))},
                       {"notes", list_to_binary(string:strip(element(7, Xt)))}}
              end,
              Items).

get_couchdb_format(Entries) ->
    lists:map(fun(Entry) ->
                      {tuple_to_list(Entry)} end, Entries).
