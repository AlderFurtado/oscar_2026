FROM golang:1.21-alpine AS build
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /votacao ./

FROM alpine:3.18
RUN addgroup -S app && adduser -S app -G app
COPY --from=build /votacao /usr/local/bin/votacao
# Copy templates so the runtime image can render HTML views
COPY --from=build /app/templates /templates
USER app
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/votacao"]
