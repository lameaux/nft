package main

import (
	"bufio"
	"flag"
	"fmt"
	"github.com/google/uuid"
	"log"
	"net"
	"net/http"
	_ "net/http/pprof"
	"net/textproto"
	"time"
)

const (
	defaultPort = 8180
	okResponse  = "lowlevel"

	httpHeader = `HTTP/1.1 %d %s
Server: golang
Date: %s
Content-Type: text/plain; charset=utf-8
Content-Length: %d

%s`
)

//http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
//	_, _ = fmt.Fprintf(w, okResponse)
//})
//
//http.HandleFunc("/uuid", func(w http.ResponseWriter, r *http.Request) {
//	_, _ = fmt.Fprintf(w, uuid.NewString())
//})

func main() {
	port := flag.Int("port", defaultPort, "port for server")
	flag.Parse()

	addr := fmt.Sprintf(":%d", *port)

	listener, err := net.Listen("tcp", addr)
	if err != nil {
		log.Fatalf("listening on %s failed: %v", addr, err)
	}
	defer listener.Close()

	log.Printf("Server listening on port %d...\n", *port)

	for {
		var conn net.Conn

		conn, err = listener.Accept()
		if err != nil {
			log.Printf("failed to accept connection: %v", err)
			continue
		}

		go handleConnection(conn)
	}

}

func handleConnection(conn net.Conn) {
	defer conn.Close()

	headers, err := readHeaders(conn)
	if err != nil {
		log.Printf("failed to read headers: %v", err)
		return
	}

	//fmt.Printf("headers: %v\n", strings.Join(headers, ","))

	handleResponse(conn, headers)
}

func readHeaders(conn net.Conn) ([]string, error) {
	reader := textproto.NewReader(bufio.NewReader(conn))

	var result []string

	for {
		line, err := reader.ReadLine()
		if err != nil {
			return nil, fmt.Errorf("failed to read line: %w", err)
		}

		if line == "" {
			break
		}

		result = append(result, line)
	}

	return result, nil
}

func handleResponse(conn net.Conn, headers []string) {
	if len(headers) == 0 {
		writeResponse(conn, http.StatusBadRequest, "")
		return
	}

	switch headers[0] {
	case "GET / HTTP/1.1":
		writeResponse(conn, http.StatusOK, okResponse)
	case "GET /uuid HTTP/1.1":
		writeResponse(conn, http.StatusOK, uuid.NewString())
	default:
		writeResponse(conn, http.StatusNotFound, "")
	}
}

func writeResponse(conn net.Conn, status int, body string) {
	resp := buildResponse(status, body)
	conn.Write([]byte(resp))
}

func buildResponse(status int, body string) string {
	length := len(body)
	date := time.Now().Format(http.TimeFormat)
	return fmt.Sprintf(httpHeader, status, http.StatusText(status), date, length, body)
}
