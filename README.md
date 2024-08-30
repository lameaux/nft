# NFT Examples

Using [bro](https://github.com/lameaux/bro) and [mox](https://github.com/lameaux/mox) for non-functional testing:

Make sure you have `make`, `docker` and `docker-compose` installed in your system.

```shell
make test

{"level":"info","version":"v0.0.1","build":"69d5dfb","time":"2024-08-30T17:14:40Z","message":"bro"}
{"level":"info","configName":"nginx vs mox","configFile":"./scenarios/04-nginx-vs-mox.yaml","time":"2024-08-30T17:14:40Z","message":"config loaded"}
{"level":"info","execution":"","time":"2024-08-30T17:14:40Z","message":"executing scenarios... press Ctrl+C (SIGINT) or send SIGTERM to terminate."}
{"level":"info","scenario":{"name":"1k from nginx","rps":1000,"threads":100,"queueSize":100,"duration":5000},"time":"2024-08-30T17:14:40Z","message":"running scenario"}
{"level":"info","scenario":{"name":"1k from mox","rps":1000,"threads":100,"queueSize":100,"duration":5000},"time":"2024-08-30T17:14:45Z","message":"running scenario"}
{"level":"info","totalDuration":10007.996422,"ok":true,"time":"2024-08-30T17:14:50Z","message":"results"}
nginx vs mox
┌───────────────┬───────┬──────┬─────────┬────────┬─────────┬─────────┬──────────────┬──────────────┬─────┬────────┐
│ SCENARIO      │ TOTAL │ SENT │ SUCCESS │ FAILED │ TIMEOUT │ INVALID │ LATENCY @P99 │     DURATION │ RPS │ PASSED │
├───────────────┼───────┼──────┼─────────┼────────┼─────────┼─────────┼──────────────┼──────────────┼─────┼────────┤
│ 1k from nginx │  5000 │ 5000 │    5000 │      0 │       0 │       0 │ 139 ms       │ 5.003642419s │ 999 │ OK     │
│ 1k from mox   │  5000 │ 5000 │    5000 │      0 │       0 │       0 │ 24 ms        │ 5.004196919s │ 999 │ OK     │
└───────────────┴───────┴──────┴─────────┴────────┴─────────┴─────────┴──────────────┴──────────────┴─────┴────────┘
Total duration: 10.007996422s
OK
```
