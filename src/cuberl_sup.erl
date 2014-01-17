% This file is part of Cuberl released under the MIT license.

-module(cuberl_sup).

-behaviour(supervisor).

-export([start_link/0]).

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
    {ok, { {one_for_one, 5, 10}, [cuberl:get_child_spec()]} }.

