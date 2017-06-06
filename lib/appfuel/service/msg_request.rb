module Appfuel
  module Service
    class MsgRequest < Appfuel::Request
      attr_reader :delivery_info, :properties

      # metadata properties
      #   headers:        message headers
      #     action_route [String]
      #   reply_to:       name of rpc response queue
      #   correlation_id: id used in rpc to match response
      #
      # @param msg            String  serialized message from rabbitmq
      # @param delivery_info  Hash    info used to acknowledge messages
      # @param properties     Object  properties of the messages
      #
      # @return MsgRequest
      def initialize(msg, delivery_info, properties)
        inputs = validate_inputs(msg)
        action_route    = properties.headers['action_route']
        @properties     = properties
        @delivery_info  = delivery_info

        super(action_route, inputs)
      end

      # Rpc requires a reply queue to respond to and a correlation_id to
      # identify that response in the queue. When these two things exist
      # then the request is consided to be an rpc
      #
      # @return [Boolean]
      def rpc?
        !reply_to.nil? && !correlation_id.nil?
      end

      def reply_to
        properties.reply_to
      end

      def correlation_id
        properties.correlation_id
      end

      private

      def validate_inputs(msg)
        msg = msg.to_s
        return {} if msg.empty?

        begin
          inputs = JSON.parse(msg)
          fail "message inputs must be a hash" unless data.is_a?(Hash)

          inputs.deep_symbolize_keys
        rescue => e
          msg = "message request could not parse the inputs: #{e.message}"
          error = RuntimeError.new(msg)
          error.set_backtrace(e.backtrace)

          raise error
        end
      end

    end
  end
end
