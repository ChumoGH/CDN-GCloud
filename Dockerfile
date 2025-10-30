FROM nginx:1.27-alpine

RUN apk add --no-cache bash
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN rm -f /etc/nginx/conf.d/default.conf || true

ENV PORT=8080
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
