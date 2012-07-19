-module(pymwyfa_web_resource).

-export([
  init/3,
  allowed_methods/2,
  content_types_provided/2,
  to_html/2
]).

init(_Transport, _Req, _Opts) ->
  {upgrade, protocol, cowboy_http_rest}.

allowed_methods(Req, State) ->
  {['GET'], Req, State}.

content_types_provided(Req, State) ->
  {[{{<<"text">>,<<"html">>, []}, to_html}], Req, State}.

to_html(Req, State) ->
  Css = random_version(4),
  Rvers = random_version(4),
  Overs = random_version(4),
  Params = [{logged_in, true},
    {user_id, <<"u1">>}, {user_name, <<"Andy Ledvina">>},
    {css_version, Css}, {route_version, Rvers},
    {other_version, Overs}],
  {ok, Content} = home_dtl:render(Params),
  {Content, Req, State}.

random_version(Size) ->
  lists:flatten(
    lists:map(
      fun(X) ->
        io_lib:format("~2.16.0b", [X])
      end,
      binary_to_list(crypto:rand_bytes(Size))
    )
  ).

