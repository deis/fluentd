FROM quay.io/deis/base:0.3.0

COPY . /

RUN apt-get update \
  && apt-get install -y \
    g++ \
    gcc \
    make \
    ruby \
    ruby-dev \
  && export FLUENTD_VERSION=0.14.0 \
  && gem install --no-document fluentd -v $FLUENTD_VERSION \
  && gem install bundler \
  && bundle install --gemfile=/opt/fluentd/deis-output/Gemfile \
  && rake --rakefile=/opt/fluentd/deis-output/Rakefile build \
  && fluent-gem install --no-document fluent-plugin-kubernetes_metadata_filter \
  && fluent-gem install --no-document fluent-plugin-elasticsearch \
  && fluent-gem install --no-document fluent-plugin-remote_syslog -v 0.3.2 \
  && fluent-gem install --no-document influxdb -v 0.3.2 \
  && fluent-gem install --no-document nsq-ruby \
  && fluent-gem install --local /opt/fluentd/deis-output/pkg/fluent-plugin-deis_output-0.1.0.gem \
  && apt-get remove -y --auto-remove --purge \
    g++ \
    gcc \
    make \
    ruby-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man /usr/share/doc

COPY /var /var

CMD ["/opt/fluentd/sbin/boot"]
