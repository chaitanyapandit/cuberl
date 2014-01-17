% This file is part of Cuberl released under the MIT license.

-record(cuberl_event, {
	  type, 
	  time, %% Cube sets it if not defined, so save bandwidth!
	  id,
	  data
}).