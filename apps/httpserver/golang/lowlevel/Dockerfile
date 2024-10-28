FROM golang:1.23-bookworm AS builder
ARG BUILD_FLAGS

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .

ENV CGO_ENABLED=0 GOOS=linux
RUN go build -o httpserver -trimpath -tags osusergo,netgo -a -ldflags="-s -w -buildid=" -gcflags="all=-m=0 -l=2 -dwarf=false" -installsuffix cgo ./cmd/*.go

FROM gcr.io/distroless/base-debian12

WORKDIR /

COPY --from=builder /app/httpserver .

ENTRYPOINT ["/httpserver"]
