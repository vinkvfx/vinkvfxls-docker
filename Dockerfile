FROM debian:bookworm

COPY vinkvfxls /usr/local/bin

RUN apt-get update && apt-get install curl

CMD [ "vinkvfxls" ]