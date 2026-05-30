FROM golang:1.26.3-alpine AS builder

WORKDIR /src

COPY --link go.sum go.sum
COPY --link go.mod go.mod
RUN go mod download

COPY --link internal internal
COPY --link main.go main.go

RUN go vet ./...
RUN go run golang.org/x/vuln/cmd/govulncheck@latest ./...

RUN CGO_ENABLED=0 go build -o /src/ghep

FROM gcr.io/distroless/static-debian12:nonroot

COPY --link --from=builder /src/ghep /

CMD ["/ghep"]
