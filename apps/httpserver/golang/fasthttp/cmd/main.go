package main

import (
	"errors"
	"flag"
	"fmt"
	"github.com/google/uuid"
	"github.com/valyala/fasthttp"
	"net/http"

	_ "net/http/pprof"
)

const (
	defaultPort = 8080
	okResponse  = "fasthttp"
)

func main() {
	port := flag.Int("port", defaultPort, "port for server")
	flag.Parse()

	requestHandler := func(ctx *fasthttp.RequestCtx) {
		switch string(ctx.Path()) {
		case "/":
			fmt.Fprint(ctx, okResponse)
		case "/uuid":
			fmt.Fprint(ctx, uuid.NewString())
		default:
			ctx.Error("Unsupported path", fasthttp.StatusNotFound)
		}
	}

	fmt.Printf("Server listening on port %d...\n", *port)

	err := fasthttp.ListenAndServe(fmt.Sprintf(":%d", *port), requestHandler)
	if err != nil && !errors.Is(err, http.ErrServerClosed) {
		fmt.Println(err)
	}
}
