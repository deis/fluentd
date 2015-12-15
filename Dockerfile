FROM alpine:3.2
MAINTAINER jchauncey@deis.com
ENV FLUENTD_VERSION 0.14.0.pre.1

RUN apk update && apk upgrade && \
    apk add ruby-json ruby-irb ruby-nokogiri ruby-thread_safe ruby-tzinfo bash && \
    apk add build-base ruby-dev && \
    apk add ruby-nokogiri jemalloc

RUN apk --update add --virtual build-dependencies build-base openssl-dev \
    libc-dev linux-headers && \
    apk add ruby-nokogiri && \
    apk del build-dependencies

RUN gem update --system --no-document && \
    gem install --no-document json_pure && \
    gem install --no-document fluentd -v ${FLUENTD_VERSION} && \
    gem install fluent-plugin-kubernetes_metadata_filter && \
    gen install fluent-plugin-elasticsearch && \
    gem install fluent-plugin-remote_syslog && \
    gem cleanup fluentd

RUN mkdir /etc/fluent
COPY fluent.conf fluent.conf
COPY start-fluentd /start-fluentd

ENTRYPOINT ["/start-fluentd"]
