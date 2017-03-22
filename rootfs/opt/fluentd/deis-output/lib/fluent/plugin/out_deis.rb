require 'fluent/mixin/config_placeholders'
require 'fluent/mixin/plaintextformatter'
require 'fluent/mixin/rewrite_tag_name'
require 'fluent/mixin/deis'
require 'fluent/output'

module Fluent
  class DeisOutput < Output
    Fluent::Plugin.register_output("deis", self)

    include Fluent::Mixin::PlainTextFormatter
    include Fluent::Mixin::ConfigPlaceholders
    include Fluent::HandleTagNameMixin
    include Fluent::Mixin::RewriteTagName
    include Fluent::Mixin::Deis

    config_param :tag, :string, :default => ""
    config_set_default :output_include_time, false
    config_set_default :output_include_tag, false
    config_set_default :num_threads, 5
    config_set_default :flush_thread_count, 5

    def initialize
      super
      @logger_nsq = nil
      @influx_nsq = nil
      @log_topic = ENV['NSQ_LOG_TOPIC'] || "logs"
      @metric_topic = ENV['NSQ_METRIC_TOPIC'] || "metrics"
      @send_logs_to_nsq = ENV['SEND_LOGS_TO_NSQ'].to_s.downcase == 'false' ? false : true
      @send_metrics_to_nsq = ENV['SEND_METRICS_TO_NSQ'].to_s.downcase == 'false' ? false : true
    end

    def start
      super
    end

    def shutdown
      super
      @logger_nsq.terminate if @logger_nsq
      @influx_nsq.terminate if @influx_nsq
    end

    def emit(tag, es, chain)
      es.each do |time, record|
        if from_controller?(record) || deis_deployed_app?(record)
          @logger_nsq ||= get_nsq_producer(@log_topic)
          record["time"] = Time.now().strftime("%FT%T.%6N%:z")
          push(@logger_nsq, record) if @send_logs_to_nsq && @logger_nsq
        end

        if from_router?(record)
          @influx_nsq ||= get_nsq_producer(@metric_topic)
          begin
            data = build_series(record)
            if data
              line = data.map do |point|
                InfluxDB::PointValue.new(point).dump
              end.join("\n".freeze)
              push(@influx_nsq, line) if @send_metrics_to_nsq && @influx_nsq
            end
          rescue Exception => e
            puts "Error:#{e.backtrace}"
          end
        end
      end
      chain.next
    end
  end
end
