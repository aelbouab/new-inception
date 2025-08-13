FROM debian:bullseye

RUN apt update && apt install mariadb-server -y

RUN  sed -i 's/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/script.sh /tmp/

RUN chmod 777 /tmp/script.sh

WORKDIR /tmp

ENTRYPOINT ["bash", "script.sh"]
