%% @author Andrew Ledvina <wvvwwvw@gmail.com>
%% @copyright 2012 Andrew Ledvina.

%% @doc pymwyfa_web startup code

-module(pymwyfa_web).
-author('Andrew Ledvina <wvvwwvw@gmail.com>').
-export([start/0, start_link/0, stop/0]).

%% @spec start_link() -> {ok,Pid::pid()}
%% @doc Starts the app for inclusion in a supervisor tree
start_link() ->
  start_common(),
  pymwyfa_web_sup:start_link().

%% @spec start() -> ok
%% @doc Start the pymwyfa_web server.
start() ->
  start_common(),
  application:start(pymwyfa_web).

%% @spec stop() -> ok
%% @doc Stop the pymwyfa_web server.
stop() ->
  Res = application:stop(pymwyfa_web),
  application:stop(cowboy),
  application:stop(ssl),
  application:stop(public_key),
  application:stop(crypto),
  Res.

%% Internal Functions

start_common() ->
  ensure_started(crypto),
  ensure_started(public_key),
  ensure_started(ssl),
  ensure_started(cowboy),
  ok.

ensure_started(App) ->
  case application:start(App) of
      ok ->
          ok;
      {error, {already_started, App}} ->
          ok
  end.

