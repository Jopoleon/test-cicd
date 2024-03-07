# Используйте официальный образ Golang как базовый
FROM golang:1.16 AS builder

# Установите рабочую директорию в контейнере
WORKDIR /app

# Копируйте и загружайте зависимости
COPY go.mod ./
COPY go.sum ./
RUN go mod download

# Копируйте исходный код проекта
COPY . .

# Соберите исполняемый файл для вашего приложения
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o myapp .

# Начните новый этап с чистого образа
FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Скопируйте бинарный файл из предыдущего этапа
COPY --from=builder /app/myapp .

# Откройте порт, который использует ваше приложение
EXPOSE 8080

# Запустите бинарный файл
CMD ["./myapp"]
