package main

import (
	"errors"
	"flag"
	"fmt"
	"github.com/google/uuid"
	"net/http"

	_ "net/http/pprof"
)

const (
	defaultPort = 8080
	okResponse  = "OK"
)

func main() {
	port := flag.Int("port", defaultPort, "port for server")
	flag.Parse()

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		_, _ = fmt.Fprintf(w, okResponse)
	})

	http.HandleFunc("/uuid", func(w http.ResponseWriter, r *http.Request) {
		_, _ = fmt.Fprintf(w, uuid.NewString())
	})

	http.HandleFunc("/file", func(w http.ResponseWriter, r *http.Request) {
		_, _ = fmt.Fprintf(w, "TODO: file")
	})

	http.HandleFunc("/mox", func(w http.ResponseWriter, r *http.Request) {
		_, _ = fmt.Fprintf(w, "TODO: mox")
	})

	http.HandleFunc("/db", func(w http.ResponseWriter, r *http.Request) {
		_, _ = fmt.Fprintf(w, "TODO: db")
	})

	fmt.Printf("Server listening on port %d...\n", *port)

	err := http.ListenAndServe(fmt.Sprintf(":%d", *port), nil)
	if err != nil && !errors.Is(err, http.ErrServerClosed) {
		fmt.Println(err)
	}
}
