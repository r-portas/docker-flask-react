# Pull latest LTS
FROM ubuntu:latest

# Install programs
RUN apt-get update && apt-get install -y \
supervisor \
nginx \
python3-pip \
curl

RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx/default /etc/nginx/sites-available/default

# Setup server
COPY server /usr/src/server
RUN cd /usr/src/server && pip3 install -r requirements.txt

# Forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443 8000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
