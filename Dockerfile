FROM alpine
ENV NEXTDNS_ARGS="-listen :5353 -report-client-info -log-queries -cache-size 10MB -max-ttl 5s"
ENV NEXTDNS_ID="abcdef"

ADD entrypoint.sh /entrypoint.sh

RUN wget -O /etc/apk/keys/nextdns.pub https://repo.nextdns.io/nextdns.pub \
  && echo https://repo.nextdns.io/apk | tee -a /etc/apk/repositories >/dev/null \
  && apk update \
  && apk add nextdns \
  && chmod +x /entrypoint.sh

EXPOSE 5353/udp
CMD [ "./entrypoint.sh" ]