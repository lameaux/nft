package main

import (
	"errors"
	"fmt"
	"net/http"
)

const port = 8080

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		_, _ = fmt.Fprintf(w, "OK")
	})

	fmt.Printf("Server listening on port %d...\n", port)

	err := http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
	if err != nil && !errors.Is(err, http.ErrServerClosed) {
		fmt.Println(err)
	}
}
