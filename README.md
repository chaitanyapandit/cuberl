cuberl
======

Erlang client for Square's Cube.

Sends events to Cube's collector over UDP.

Quick Start
===========

Include these configuration options in your app's sys.config/app.config

```shell
{cuberl, [
    {host, "127.0.0.1"}, %% Or wherever the collector is running
    {port, 1180} %% UDP port
]},
```


