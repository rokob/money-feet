-module(home_handler).

-export([
  init/3,
  allowed_methods/2,
  content_types_accepted/2,
  content_types_provided/2,
  get_json/2,
  put_json/2
]).

init(_Transport, _Req, _Opts) ->
  {upgrade, protocol, cowboy_http_rest}.

allowed_methods(Req, State) ->
  {['HEAD', 'GET', 'PUT'], Req, State}.

content_types_accepted(Req, State) ->
  Types = [
    {{<<"application">>, <<"json">>, []}, put_json}
  ],
  {Types, Req, State}.

content_types_provided(Req, State) ->
  Types = [
    {{<<"application">>, <<"json">>, []}, get_json}
  ],
  {Types, Req, State}.

put_json(Req, State) ->
  {ok, Body, Req1} = cowboy_http_req:body(Req),
  {Json} = jiffy:decode(Body),
  Name = proplists:get_value(<<"name">>, Json),
  Resp = jiffy:encode({[{<<"hello">>, Name}]}),
  {ok, Req2} = cowboy_http_req:set_resp_header('Content-Type',
    <<"application/json">>, Req1),
  {ok, Req3} = cowboy_http_req:set_resp_body(Resp, Req2),
  {true, Req3, State}.

get_json(Req, State) ->
  Hello = <<"{\"hello\":\"world\"}">>,
  {Hello, Req, State}.
