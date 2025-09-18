FROM debian:bookworm

RUN     apt update && apt upgrade -y && apt install -y nginx openssl

RUN    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/ssl/private/nginx-selfsigned.key \
        -out /etc/ssl/certs/nginx-selfsigned.crt \
        -subj "/C=MO/ST=KHOURIBGA/L=KHOURIBGA/O=1337/OU=student/CN=aelbouab.42.fr"

COPY    ./tools/nginx.conf /etc/nginx/conf.d/

ENTRYPOINT ["nginx", "-g", "daemon off;"]
