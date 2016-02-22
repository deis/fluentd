FROM alpine:3.2

RUN apk --update add build-base ca-certificates ruby-dev bash \
     && rm -rf /var/cache/apk/*

ENV FLUENTD_VERSION 0.14.0.pre.1

RUN echo 'gem: --no-document' >> /etc/gemrc
RUN gem install fluentd -v $FLUENTD_VERSION && \
    gem install --no-document fluent-plugin-kubernetes_metadata_filter && \
    gem install --no-document fluent-plugin-elasticsearch && \
    gem install --no-document fluent-plugin-remote_syslog

# add logger user
RUN addgroup -S fluentd && \
	  adduser -S -G fluentd -H -h /fluentd -D fluentd && \
    mkdir -p /fluentd

COPY fluent.conf /fluentd/fluent.conf
COPY start-fluentd /start-fluentd

RUN chown -R fluentd:fluentd /fluentd

ENV FLUENTD_CONF="fluent.conf"

ENTRYPOINT ["/start-fluentd"]
ENV DEIS_RELEASE v2-beta