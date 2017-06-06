module Appfuel
  module Service
    class MsgRequest < Appfuel::Request
      attr_reader :delivery_info, :properties

      def initialize(msg, delivery_info, properties)
        inputs = validate_inputs(msg)
        action_route    = properties.headers['action_route']
        @properties     = properties
        @delivery_info  = delivery_info

        super(action_route, inputs)
      end

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
