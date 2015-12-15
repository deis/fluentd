## Description
This is an [alpine 3.2](http://www.alpinelinux.org/) based image for running [fluentd](http://fluentd.org). It is built for the purpose of running on a kubernetes cluster.

This work is based on the [docker-fluentd](https://github.com/fabric8io/docker-fluentd) and [docker-fluentd-kubernetes](https://github.com/fabric8io/docker-fluentd-kubernetes) images by the fabric8 team. This image is in with [deis](https://github.com/deis/deis) v2 to send all log data to the [logger](https://github.com/deis/logger) component.

## Plugins

### fluent-plugin-kubernetes_metadata_filter
This plugin is used to decorate all log entries with kubernetes metadata. More information on the plugin can be found [here](https://github.com/fabric8io/fluent-plugin-kubernetes_metadata_filter)

### fluent-plugin-elasticsearch
Allows fluentd to send log data to an elastic search cluster. You must specify an `ELASTICSEARCH_HOST` environment variable for this plugin to work.

### fluent-plugin-remote_syslog
This plugin allows `fluentd` to send data to a remote syslog endpoint like [papertrail](http://papertrailapp.com). You can configure `fluentd` to talk to multiple remote syslog endpoints by using the following scheme:
* `SYSLOG_HOST_1=some.host`
* `SYSLOG_PORT_1=514`
* `SYSLOG_HOST_2=some.other.host`
* `SYSLOG_PORT_2=52232`

You can also set `SYSLOG_HOST` and `SYSLOG_PORT`.
