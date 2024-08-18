# NFT Examples

Using [bro](https://github.com/lameaux/bro) and [mox](https://github.com/lameaux/mox) for non-functional testing:

```shell
make test

{"level":"info","version":"v0.0.1","build":"36db22b","time":"2024-08-18T17:29:24Z","message":"bro"}
{"level":"info","configName":"Simple Constant Rate Demo","configFile":"./scenarios/01-simple-constant-rate.yaml","time":"2024-08-18T17:29:24Z","message":"config loaded"}
{"level":"info","execution":"","time":"2024-08-18T17:29:24Z","message":"executing scenarios... press Ctrl+C (SIGINT) or send SIGTERM to terminate."}
{"level":"info","scenario":{"name":"100 RPS","rate":100,"interval":1000,"vus":20,"duration":5000},"time":"2024-08-18T17:29:24Z","message":"running scenario"}
{"level":"info","scenario":{"name":"1k RPS","rate":1000,"interval":1000,"vus":100,"duration":15000},"time":"2024-08-18T17:29:29Z","message":"running scenario"}
{"level":"info","totalDuration":20005.559217,"ok":true,"time":"2024-08-18T17:29:44Z","message":"results"}
┌──────────┬───────┬───────┬─────────┬────────┬─────────┬─────────┬──────────────┬───────────────┬──────┬────────┐
│ SCENARIO │ TOTAL │  SENT │ SUCCESS │ FAILED │ TIMEOUT │ INVALID │ LATENCY @P99 │      DURATION │  RPS │ PASSED │
├──────────┼───────┼───────┼─────────┼────────┼─────────┼─────────┼──────────────┼───────────────┼──────┼────────┤
│ 100 RPS  │   500 │   500 │     500 │      0 │       0 │       0 │ 13 ms        │  5.003271835s │  100 │ OK     │
│ 1k RPS   │ 15000 │ 15000 │   15000 │      0 │       0 │       0 │ 72 ms        │ 15.002036299s │ 1000 │ OK     │
└──────────┴───────┴───────┴─────────┴────────┴─────────┴─────────┴──────────────┴───────────────┴──────┴────────┘
Total duration: 20.005559217s
OK
```
