% This file is part of Cuberl released under the MIT license.

-module(cuberl_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    cuberl_sup:start_link().

stop(_State) ->
    ok.
