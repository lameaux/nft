FROM golang:1.22-alpine AS builder

WORKDIR /

COPY go.mod ./
RUN go mod download

COPY . .
RUN go build -o httpserver ./cmd/*.go

FROM alpine:latest

WORKDIR /

COPY --from=builder /httpserver .

ENTRYPOINT ["/httpserver"]
