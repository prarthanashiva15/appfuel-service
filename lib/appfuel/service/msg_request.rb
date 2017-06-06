module Appfuel
  module Service
    class MsgRequest < Appfuel::Request
      # Properties is a Hash like structure that holds attributes of the
      # message as defined by the amqp protocol
      #
      #   :content_type       (Optional) content type of the message, as set by
      #                       the publisher
      #
      #   :content_encoding   (Optional) content encoding of the message, as set
      #                       by the publisher
      #
      #   :headers            message headers
      #
      #   :delivery_mode      [Integer] Delivery mode (persistent or transient)
      #
      #   :priority           [Integer] Message priority, as set by the publisher
      #
      #   :correlation_id     [String] What message this message is a reply to
      #                       (or corresponds to), as set by the publisher
      #
      #   :reply_to           [String] (Optional) How to reply to the publisher
      #                       (usually a reply queue name)
      #
      #   :expiration         [String] Message expiration, as set by the publisher
      #
      #   :message_id         [String] Message ID, as set by the publisher
      #
      #   :timestamp          [Time] Message timestamp, as set by the publisher
      #
      #   :user_id            [String] Publishing user, as set by the publisher
      #                       not an application user
      #
      #   :app_id             [String] Publishing application, as set by the
      #                       publisher
      #
      #   :cluster_id         [String] Cluster ID, as set by the publisher
      #
      #
      # Delivery Info is a Hash like structure that hold information about the
      # delivery of the message
      #
      #   :consumer_tag   Each consumer (subscription) has an identifier called a
      #                   consumer tag. It can be used to unsubscribe from
      #                   messages. Consumer tags are just strings.
      #
      #   :delivery_tag   If set to 1, the delivery tag is treated as
      #                   "up to and including", so that multiple messages can be
      #                   acknowledged with a single method. If set to zero, the
      #                   delivery tag refers to a single message. If the multiple
      #                   field is 1, and the delivery tag is zero, this indicates
      #                   acknowledgement of all outstanding messages.
      #
      #   :redelivered    true if this delivery is a redelivery ( the message was
      #                   requeued at least once )
      #
      #   :routing_key    routing key used by exchange to route to queue
      #
      #   :exchange       name of exchange
      #
      #   :consumer       the consumer that subsribed
      #
      #   :channel        the channel the message was sent on
      attr_reader :delivery_info, :properties

      # metadata properties
      #   headers:        message headers, important for service_route
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
