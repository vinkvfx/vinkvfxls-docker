FROM alpine:3.21.3

COPY vinkvfxls /usr/local/bin

RUN apk add curl

CMD [ "vinkvfxls" ]