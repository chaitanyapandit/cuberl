% This file is part of Cuberl released under the MIT license.

-define(NOW(), iso8601:format(calendar:universal_time())).

-record(cuberl_event, {
	  type, 
	  time = ?NOW(), %% Ignored if set to undefined
	  id,
	  data
}).