FROM golang:1.20 AS builder
WORKDIR /build
COPY main.go ./app.go
RUN adduser \
  --disabled-password \
  --gecos "" \
  --shell "/sbin/nologin" \
  --no-create-home \
  --uid "10001" \
  "appuser"
RUN CGO_ENABLED=0 GO111MODULE=off go build -a -installsuffix cgo -o app

FROM scratch
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
COPY --from=builder /build/app /app
USER appuser:appuser
EXPOSE 8090
ENTRYPOINT ["/app"]
