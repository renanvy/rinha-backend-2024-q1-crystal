# Build image
FROM crystallang/crystal:1.2.1-alpine as builder
WORKDIR /app
# Cache dependencies
COPY ./shard.yml ./shard.lock /app/
RUN shards install --production -v
# Build a binary
COPY . /app/
RUN shards build --no-debug --static
# ===============
# Result image with one layer
FROM alpine:latest
WORKDIR /
COPY --from=builder /app/bin/rinha-backend-2024-q1-crystal .
ENTRYPOINT ["/rinha-backend-2024-q1-crystal"]
