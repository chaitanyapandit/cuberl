% This file is part of Cuberl released under the MIT license.

-record(cuberl_event, {
	  type, 
	  time,
	  id,
	  data
}).

-define(record_to_proplist(Ref, Rec), lists:zip(record_info(fields, Rec),tl(tuple_to_list(Ref)))).
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).