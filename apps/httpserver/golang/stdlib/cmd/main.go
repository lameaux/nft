package main

import (
	"errors"
	"fmt"
	"github.com/google/uuid"
	"net/http"
)

const port = 8080

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		_, _ = fmt.Fprintf(w, "OK")
	})

	http.HandleFunc("/uuid", func(w http.ResponseWriter, r *http.Request) {
		_, _ = fmt.Fprintf(w, uuid.NewString())
	})

	http.HandleFunc("/file", func(w http.ResponseWriter, r *http.Request) {
		_, _ = fmt.Fprintf(w, "file")
	})

	http.HandleFunc("/mox", func(w http.ResponseWriter, r *http.Request) {
		_, _ = fmt.Fprintf(w, "mox")
	})

	http.HandleFunc("/db", func(w http.ResponseWriter, r *http.Request) {
		_, _ = fmt.Fprintf(w, "postgres")
	})

	fmt.Printf("Server listening on port %d...\n", port)

	err := http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
	if err != nil && !errors.Is(err, http.ErrServerClosed) {
		fmt.Println(err)
	}
}
