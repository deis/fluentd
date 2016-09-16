## Description

Deis (pronounced DAY-iss) is an open source PaaS that makes it easy to deploy and manage
applications on your own servers. Deis builds on [Kubernetes](http://kubernetes.io/) to provide
a lightweight, [Heroku-inspired](http://heroku.com) workflow.

![Deis Graphic](https://s3-us-west-2.amazonaws.com/get-deis/deis-graphic-small.png)

## About
This is an centos7 based image for running [fluentd](http://fluentd.org). It is built for the purpose of running on a kubernetes cluster.

This work is based on the [docker-fluentd](https://github.com/fabric8io/docker-fluentd) and [docker-fluentd-kubernetes](https://github.com/fabric8io/docker-fluentd-kubernetes) images by the fabric8 team. This image is in with [deis](https://github.com/deis/deis) v2 to send all log data to the [logger](https://github.com/deis/logger) component.

## Plugins

### [fluent-plugin-kubernetes_metadata_filter](https://github.com/fabric8io/fluent-plugin-kubernetes_metadata_filter)
This plugin is used to decorate all log entries with kubernetes metadata.

### [fluent-plugin-elasticsearch](https://github.com/uken/fluent-plugin-elasticsearch)
Allows fluentd to send log data to an elastic search cluster. You must specify an `ELASTICSEARCH_HOST` environment variable for this plugin to work.

### [fluent-plugin-remote_syslog](https://github.com/dlackty/fluent-plugin-remote_syslog)
This plugin allows `fluentd` to send data to a remote syslog endpoint like [papertrail](http://papertrailapp.com). You can configure `fluentd` to talk to multiple remote syslog endpoints by using the following scheme:
* `SYSLOG_HOST_1=some.host`
* `SYSLOG_PORT_1=514`
* `SYSLOG_HOST_2=some.other.host`
* `SYSLOG_PORT_2=52232`

You can also set `SYSLOG_HOST` and `SYSLOG_PORT`.

### [fluent-plugin-sumologic](https://github.com/mattk42/fluent-plugin-sumologic)
This plugin allows for `fluentd` to send all log data to a sumologic endpoint. You can configure it using the following environment variables:
* `SUMOLOGIC_COLLECTOR_URL`
* `SUMOLOGIC_ENDPOINT`
* `SUMOLOGIC_HOST`
* `SUMOLOGIC_PORT` : defaults to 80 (unless `IS_HTTPS` is set and then its 443)
* `IS_HTTPS`

### Deis Output
Deis output is a custom fluentd plugin that was written to forward data directly to deis components while filtering out data that we did not care about. We have 2 pieces of information we care about currently.

1) Logs from applications that are written to stdout within the container and the controller logs that represent actions against those applications. These logs are sent to an internal messaging system ([NSQ](http://nsq.io)) on a configurable topic. The logger component then reads those messages and stores the data in an ring buffer.

2) Metric data from the nginx based router. We take the log and parse out `request_time`, `response_time`, and `bytes_sent`. Each one of these metrics makes up a series that we will ultimately send to our InfluxDB system. Attached to each series is the host the data came from (where router is running) and the status code for that request.

The topics these messages are put on are configurable via environment variables.
* `NSQ_LOG_TOPIC`
* `NSQ_METRIC_TOPIC`

### Custom Plugins
If you need something beyond the plugins that come pre-installed in the image, it is possible to set some environment variables to install and configure custom plugins as well.

To install a custom plugin, simply set a FLUENTD_PLUGIN_# environment variable. For multiple plugins simply increment the trailing number.
`FLUENTD_PLUGIN_1=some-fluentd-plugin`

To configure your custom plugins, use either the CUSTOM_STORE_# or CUSTOM_FILTER_# environment variables
* `CUSTOM_STORE_1="configuration text"`
* `CUSTOM_FILTER_1="configuration text"`

If you need the build tools available for installing your plugin, this can be enabled with another environment variable
`INSTALL_BUILD_TOOLS="true"`
