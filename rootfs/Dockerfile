FROM quay.io/deis/base:0.2.0

COPY . /

RUN apt-get update \
	&& apt-get install -y \
		g++ \
		gcc \
		make \
		ruby \
		ruby-dev \
	&& echo 'gem: --no-document' >> /etc/gemrc \
	&& export FLUENTD_VERSION=0.14.0.pre.1 \
	&& gem install --no-document fluentd -v $FLUENTD_VERSION \
	&& gem install --no-document fluent-plugin-kubernetes_metadata_filter \
	&& gem install --no-document fluent-plugin-elasticsearch \
	&& gem install --no-document fluent-plugin-remote_syslog -v 0.3.2 \
	&& apt-get remove -y --auto-remove --purge \
		g++ \
		gcc \
		make \
		ruby-dev \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man /usr/share/doc

# Re-copy this monkey patch because a previous step would have overwritten it
COPY var/lib/gems/2.3.0/gems/fluent-plugin-remote_syslog-0.3.2/lib/fluent/plugin/out_remote_syslog.rb /var/lib/gems/2.3.0/gems/fluent-plugin-remote_syslog-0.3.2/lib/fluent/plugin/out_remote_syslog.rb

CMD ["/opt/fluentd/sbin/boot"]

ENV WORKFLOW_RELEASE 2.0.0
