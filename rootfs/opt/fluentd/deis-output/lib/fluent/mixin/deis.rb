require 'json'
require 'nsq'
require 'influxdb'
require 'yajl/json_gem'

module Fluent
  module Mixin
    module Deis
      LOGGER_URL = "http://#{ENV['DEIS_LOGGER_SERVICE_HOST']}:#{ENV['DEIS_LOGGER_SERVICE_PORT_HTTP']}/logs"
      INFLUX_HOST = "#{ENV['DEIS_MONITOR_INFLUXAPI_SERVICE_HOST']}"
      INFLUX_PORT = "#{ENV['DEIS_MONITOR_INFLUXAPI_SERVICE_PORT_TRANSPORT']}"
      INFLUX_DATABASE = ENV['INFLUX_DATABASE'] || "kubernetes"
      NSQ_URL = "#{ENV['DEIS_NSQD_SERVICE_HOST']}:#{ENV['DEIS_NSQD_SERVICE_PORT_TRANSPORT']}"

      def kubernetes?(message)
        return message["kubernetes"] != nil
      end

      def from_controller?(message)
        if from_container?(message, "deis-controller")
          return message["log"] =~ /^(INFO|WARN|DEBUG|ERROR)\s+(\[(\S+)\])+:(.*)/
        end
        return false
      end

      def from_router?(message)
        return from_container?(message, "deis-router")
      end

      def from_container?(message, regex)
        if kubernetes? message
          return true if Regexp.new(regex).match(message["kubernetes"]["container_name"]) != nil
        end
        return false
      end

      def deis_deployed_app?(message)
        if kubernetes? message
          labels = message["kubernetes"]["labels"]
          return true if message["kubernetes"]["namespace_name"] != "deis" && labels["heritage"] == "deis" && labels["app"] != nil
        end
        return false
      end

      def push(producer, value)
        begin
          if value.kind_of? Hash
            producer.write(JSON.dump(value))
          else
            producer.write(value)
          end
        rescue Exception => e
          puts "Error:#{e.message}"
          puts e.backtrace
        end
      end

      def build_series(message)
        metric = parse_router_log(message["log"], message["kubernetes"]["host"])
        if metric
          tags = { app: metric["app"], status_code: metric["status_code"], host: metric["host"] }
          data = [
            {
              series: 'deis_router_request_time_ms',
              values: { value: metric["request_time"] },
              tags: tags
            },
            {
              series: 'deis_router_response_time_ms',
              values: { value: metric["response_time"] },
              tags: tags
            },
            {
              series: 'deis_router_bytes_sent',
              values: { value: metric["bytes_sent"] },
              tags: tags
            },
          ]
          return data
        end
        return nil
      end

      # {"log"=>"[2016-05-31T16:56:12+00:00] - foo - 10.164.1.1 - - - 200 - \"GET / HTTP/1.0\" - 211 - \"-\" - \"ApacheBench/2.3\" - \"~^foo\\x5C.(?<domain>.+)$\" - 10.167.243.4:80 - foo.devart.io - 0.002 - 0.046\n"}
      # request_time - request processing time in seconds with a milliseconds resolution; time elapsed between the first bytes were read from the client and the log write after the last bytes were sent to the client
      # response_time - keeps time spent on receiving the response from the upstream server; the time is kept in seconds with millisecond resolution.
      def parse_router_log(message, host)
        begin
          split_message = message.split(" - ")
          return nil if split_message.length < 14
          metric = {}
          metric["app"] = split_message[1].strip
          metric["status_code"] = split_message[4].strip
          metric["bytes_sent"] = split_message[6].strip.to_f
          metric["response_time"] = split_message[12].strip.to_f
          metric["request_time"] = split_message[13].strip.to_f
          metric["host"] = host
          return metric
        rescue Exception => e
          puts "Error:#{e.message}"
          return nil
        end
      end

      def debug?
        ENV["DEBUG"] == "true"
      end

      def get_nsq_producer(topic)
        begin
          puts "Creating nsq producer (#{NSQ_URL}) for topic:#{topic}"
          return Nsq::Producer.new(nsqd: NSQ_URL, topic: topic)
        rescue Exception => e
          puts "Error:#{e.message}"
          return nil
        end
      end
    end
  end
end
