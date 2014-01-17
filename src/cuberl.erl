% This file is part of Cuberl released under the MIT license.

-module(cuberl).
 
-behaviour(gen_server).
 
-include("cuberl.hrl").
  
-export([start_link/0,
	 get_child_spec/0]).

-export([init/1,
	 handle_call/3,
	 handle_cast/2,
	 code_change/3,
	 handle_info/2,
	 terminate/2]).
	
-export([send/1,
		test/0]).
	  
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).
-define(record_to_proplist(Ref, Rec), lists:zip(record_info(fields, Rec),tl(tuple_to_list(Ref)))).

-record(state, {
    host,
    port,
    socket
}).
 
%%%----------------------------------------------------------------------
%%% gen_server
%%%----------------------------------------------------------------------

get_child_spec()->
	?CHILD(?MODULE, worker).
 
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
 
init([]) ->	
	{ok, Host} = application:get_env(cuberl, host),	
	{ok, Port} = application:get_env(cuberl, port),
	{ok, Socket} = gen_udp:open(0, [binary]),
	{ok, #state {
	    host = lookup_hostname(Host),
	    port = Port,
	    socket = Socket
	}}.
 
handle_call(_Request, _From, State) ->
    {reply, ignored, State}.
 
handle_cast({send, Event}, State) when is_binary(Event) ->
    Res = gen_udp:send(State#state.socket, State#state.host, State#state.port, Event),
    {noreply, State};
	
handle_cast({send, Event}, State) when is_record(Event, cuberl_event)->
	handle_cast({send, ?record_to_proplist(Event, cuberl_event)}, State);

handle_cast({send, Event}, State) ->
	handle_cast({send, jiffy:encode(pack_json(Event))}, State);
	
handle_cast(_Msg, State) ->
    {noreply, State}.
 
handle_info(_Info, State) ->
    {noreply, State}.
 
terminate(_Reason, _State) ->
    ok.
 
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%----------------------------------------------------------------------
%%% core
%%%----------------------------------------------------------------------

send(Event) ->
    gen_server:cast(?MODULE, {send, Event}).
		
%%%----------------------------------------------------------------------
%%% helpers
%%%----------------------------------------------------------------------

lookup_hostname(Address) when is_tuple(Address) ->
    Address;
lookup_hostname(Host) ->
    case inet:gethostbyname(Host) of
        {ok, {_, _, _, _, _, [Address | _]}} ->
            Address;
        _Else ->
            {127, 0, 0, 1}
    end.
	
%%%===================================================================
%%% JSON helpers
%%%===================================================================

%% List of tuples, put in a document
pack_json([{_,_}|_] = Doc) ->
	{[pack_json(X) || X <- Doc, is_valid(X)]};
%% List of lists, put in a list
pack_json([H|T] = Doc) ->
	[pack_json(X) || X <- Doc, is_valid(X)];
%% Data types
pack_json({K, V} = Pack) ->
	{pack_json(K), pack_json(V)};
pack_json(Other) ->
	Other.
%% Unpacking
unpack_json({K, V}) ->
	{unpack_json(K), unpack_json(V)};
unpack_json({L}) when is_list(L) ->
	[unpack_json(X) || X <- L];
unpack_json(L) when is_list(L) ->
	[unpack_json(X) || X <- L];
unpack_json(Other) ->
	Other.	
is_valid({_, undefined}) ->
	false;
is_valid(Other) ->
	true.

%%%===================================================================
%%% test
%%%===================================================================
	
test() ->
	send(#cuberl_event{type = <<"verbs2">>, data=[{<<"value">>, random:uniform(1000)}]}).
