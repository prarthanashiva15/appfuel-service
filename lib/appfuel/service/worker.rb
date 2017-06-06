module Appfuel
  module Service
    class Worker
      include Sneakers::Worker
      include Appfuel::Application::AppContainer
      include Appfuel::Application::Dispatcher

      class << self
        def inherited(klass)
          stage_class_for_registration(klass)
        end
      end

      # Sneakers worker hook to handle messages from RabbitMQ
      #
      #
      # @param msg [String] JSON string of inputs
      # @param delivery_info [Bunny::Delivery::Info]
      # @param properties [Bunny::MessageProperties]
      # @return [Appfuel::Response]
      def work_with_params(msg, delivery_info, properties)
        container = app_container
        request   = create_request(msg, delivery_info, properties)
        response  = dispatch(request, container)

        if request.rpc?
          publish_rpc(request, response)
        end

        ack!
        response
      end


      # Publish a response for the rpc request.
      #
      # @param request [MsgRequest]
      # @param respons [Appfuel::Response]
      # @return [Nil]
      def publish_rpc(request, response)
        options = {
          correlation_id: request.correlation_id,
          routing_key: request.reply_to,
          headers: { "action_route" => request.action_route }
        }
        publish(response.to_json, options)
        nil
      end

      private

      def create_request(msg, delivery_info, properties)
        Appfuel::Service::MsgRequest.new(msg, delivery_info, properties)
      end
    end
  end
end
