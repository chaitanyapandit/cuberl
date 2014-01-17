# cuberl #

Erlang client for Square's Cube.

Sends events to Cube's collector over UDP.

## Quick Start ##

Add cuberl to your `rebar.config` deps:

    {cuberl, ".*", {git, "git://github.com/chaitanyapandit/cuberl.git"}}

Don't forget to include `cuberl` and `iso8601` in your application (in the reltool.config rel section):
	
	...[
		 cuberl,
		 iso8601
		 ]...
		 
	{app, cuberl, [{incl_cond, include}]},
	{app, iso8601, [{incl_cond, include}]}


The cuberl application itself needs to be configured using the application's environment, this is generally done in `app.config` or `sys.config`.

```shell
{cuberl, [
    {host, "127.0.0.1"}, %% Or wherever the collector is running
    {port, 1180} %% UDP port
]}
```

Include `cuberl.hrl`:

    -include("../deps/cuberl/include/cuberl.hrl").



