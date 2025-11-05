FROM golang:alpine AS build
RUN apk --no-cache add git build-base
WORKDIR /app
COPY backend/go.mod backend/go.sum ./
RUN go mod download
COPY backend/ .
ENV GIN_MODE=release
ENV CGO_ENABLED=1
RUN go build -o main .

FROM debian:bookworm-slim
WORKDIR /app
COPY --from=build /app/main .
EXPOSE 53164
CMD ["./main"]