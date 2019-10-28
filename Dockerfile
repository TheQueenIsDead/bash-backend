FROM ubuntu:18.04

RUN apt update -y && apt upgrade -y
RUN apt install -y \
    socat \
    jq \
    bc

WORKDIR /app

COPY bash-calc.sh .
COPY bashttpd.conf .

EXPOSE 8080

CMD ["socat", "TCP4-LISTEN:8080", "EXEC:/app/bash-calc.sh"]