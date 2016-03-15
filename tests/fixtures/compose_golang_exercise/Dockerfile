FROM golang:1.5-alpine

WORKDIR /app

COPY main.go /app/main.go

RUN apk update
RUN apk add git
RUN go get gopkg.in/mgo.v2
RUN go build /app/main.go

EXPOSE 8080

CMD ["./main"]