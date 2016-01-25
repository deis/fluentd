FROM alpine:3.2

RUN apk --update add build-base ca-certificates ruby-dev bash \
     && rm -rf /var/cache/apk/*

ENV FLUENTD_VERSION 0.14.0.pre.1

RUN echo 'gem: --no-document' >> /etc/gemrc
RUN gem install fluentd -v $FLUENTD_VERSION && \
    gem install --no-document fluent-plugin-kubernetes_metadata_filter && \
    gem install --no-document fluent-plugin-elasticsearch && \
    gem install --no-document fluent-plugin-remote_syslog

RUN mkdir -p /fluentd

COPY fluent.conf /fluentd/fluent.conf
COPY start-fluentd /start-fluentd

ENV FLUENTD_CONF="fluent.conf"

ENTRYPOINT ["/start-fluentd"]
