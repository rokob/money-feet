
-module(pymwyfa_web_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).


%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
  RestartStrategy = one_for_one,
  MaxRestarts = 1000,
  MaxSecondsBetweenRestarts = 3600,
  
  SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},
  
  Restart = permanent,
  Shutdown = 5000,
  Type = worker,
  WebConfig = conf:get_section(web),
  
  Web = {cowboy,
        {cowboy, start_listener, WebConfig},
        Restart, Shutdown, Type, [cowboy]},

  Processes = [Web],

  {ok, {SupFlags, Processes}}.
