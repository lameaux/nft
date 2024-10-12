FROM golang:1.23-bookworm AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .
RUN go build -o httpserver ./cmd/*.go

FROM gcr.io/distroless/base-debian12

WORKDIR /

COPY --from=builder /app/httpserver .

ENTRYPOINT ["/httpserver"]
