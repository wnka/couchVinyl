#!/opt/local/bin/escript
%% -*- erlang -*-

main(_) ->
    code:add_patha("./lib"),
    application:start(crypto),
    application:start(couchbeam),
    couchbeam:open_connection({"wnka", {"127.0.0.1", 5984}}),
    Lines=record_read:readlines("vinyl.txt"),
    Items = record_read:get_items(Lines),
    Records = record_read:get_entries(Items),
    Couch = record_read:get_couchdb_format(Records),
    lists:map(fun(X) -> couchbeam:save_doc(wnka, "vinyl", X) end, Couch).

