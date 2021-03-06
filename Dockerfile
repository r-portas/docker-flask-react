# Pull latest LTS
FROM ubuntu:latest

# Install programs
RUN apt-get update && apt-get install -y \
supervisor \
nginx \
python3-pip \
curl \
git

RUN mkdir -p /var/log/supervisor

MAINTAINER Roy Portas


# Setup server
RUN git clone https://github.com/r-portas/docker-flask-react.git /usr/src
RUN cd /usr/src/server && pip3 install -r requirements.txt

RUN cp /usr/src/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN cp /usr/src/nginx/default /etc/nginx/sites-available/default

# Forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
