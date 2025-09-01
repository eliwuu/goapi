# Build stage
FROM golang:1.25 AS builder

WORKDIR /app

# Cache dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy source
COPY . .

# Build binary
RUN go build -o goapi .

# Run stage
FROM debian:bookworm-slim

WORKDIR /root/

# Install CA certificates (needed for HTTPS calls)
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/goapi .

# Expose app port
EXPOSE 8080

CMD ["./goapi"]