# NFT Examples

Using [bro](https://github.com/lameaux/bro) and [mox](https://github.com/lameaux/mox) for non-functional testing:

```shell
make test

Total duration: 20.007343052s
┌──────────┬────────────────┬───────┬────────────┬────────┬─────────┬─────────┬──────────────┬───────────────┐
│ SCENARIO │ TOTAL REQUESTS │  SENT │ SUCCESSFUL │ FAILED │ TIMEOUT │ INVALID │ LATENCY @P99 │ DURATION      │
├──────────┼────────────────┼───────┼────────────┼────────┼─────────┼─────────┼──────────────┼───────────────┤
│ 100 RPS  │            500 │   500 │        500 │      0 │       0 │       0 │ 14 ms        │ 5.005843169s  │
│ 1k RPS   │          15000 │ 15000 │      15000 │      0 │       0 │       0 │ 64 ms        │ 15.001300174s │
└──────────┴────────────────┴───────┴────────────┴────────┴─────────┴─────────┴──────────────┴───────────────┘
```
