% This file is part of Cuberl released under the MIT license.

-define(NOW(), iso8601:format(calendar:universal_time())).

-record(cuberl_event, {
	  type, 
	  time = ?NOW(), %% Ignored if set to undefined
	  id,
	  data
}).

-define(record_to_proplist(Ref, Rec), lists:zip(record_info(fields, Rec),tl(tuple_to_list(Ref)))).
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).