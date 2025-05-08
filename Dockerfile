FROM alpine
ENV NEXTDNS_ARGS="-listen 0.0.0.0:53 -report-client-info -log-queries -cache-size 10MB -max-ttl 5s"
ENV NEXTDNS_ID="abcdef"

COPY entrypoint.sh /entrypoint.sh

RUN wget -qO /etc/apk/keys/nextdns.pub https://repo.nextdns.io/nextdns.pub \
  && echo https://repo.nextdns.io/apk | tee -a /etc/apk/repositories >/dev/null \
  && apk update \
  && apk add --no-cache bind-tools nextdns \
  && rm -rf /var/cache/apk/* \
  && chmod +x /entrypoint.sh

HEALTHCHECK --interval=60s --timeout=10s --start-period=5s --retries=1 \
  CMD dig +time=20 @127.0.0.1 -p 53 probe-test.dns.nextdns.io && dig +time=20 @127.0.0.1 -p 53 probe-test.dns.nextdns.io

EXPOSE 53/tcp
EXPOSE 53/udp
CMD [ "./entrypoint.sh" ]