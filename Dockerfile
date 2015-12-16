FROM centos:7
MAINTAINER jchauncey@deis.com

RUN yum update -y && \
    yum install -y https://www.softwarecollections.org/en/scls/rhscl/rh-ruby22/epel-7-x86_64/download/rhscl-rh-ruby22-epel-7-x86_64.noarch.rpm && \
    yum install -y net-tools scl-utils make gcc gcc-c++ bzip2 rh-ruby22 rh-ruby22-ruby-devel && \
    yum clean all

ENV FLUENTD_VERSION 0.14.0.pre.1
ENV LD_LIBRARY_PATH /opt/rh/rh-ruby22/root/usr/lib64

RUN scl enable rh-ruby22 'gem update --system --no-document' && \
    scl enable rh-ruby22 'gem install --no-document json_pure jemalloc' && \
    scl enable rh-ruby22 "gem install --no-document fluentd -v ${FLUENTD_VERSION}" && \
    scl enable rh-ruby22 'gem install --no-document fluent-plugin-kubernetes_metadata_filter' && \
    scl enable rh-ruby22 'gem install --no-document fluent-plugin-elasticsearch' && \
    scl enable rh-ruby22 'gem install --no-document fluent-plugin-remote_syslog' && \
    scl enable rh-ruby22 'gem cleanup fluentd' && \
    ln -s /opt/rh/rh-ruby22/root/usr/local/bin/* /usr/bin

RUN mkdir /etc/fluent
COPY fluent.conf /etc/fluent/fluent.conf
COPY start-fluentd /start-fluentd

ENTRYPOINT ["/start-fluentd"]
