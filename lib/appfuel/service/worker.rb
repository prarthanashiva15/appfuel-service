module Appfuel
  module Service
    class Worker
      include Sneakers::Worker
      include Appfuel::Application::AppContainer
      include Appfuel::Application::Dispatcher

      def work_with_params(msg, delivery_info, metadata)
        container = app_container
        request   = create_request(msg, delivery, metadata)
        response  = dispatch(request, container)

        config = app_container[:config]
        if config.key?(:audit_logger)

        end

        if request.rpc?
          publish_rpc(request, response)
        end

        ack!
      end


      def public_rpc(request, response)
        options = {
          correlation_id: request.correlation_id,
          routing_key: request.reply_to,
          headers: { "action_route" => request.action_route }
        }
        publish(response.to_json, options)
      end

      private

      def create_request(msg, delivery_info, metadata)
        Appfuel::Service::MsgRequest.new(msg, delivery, metadata)
      end
    end
  end
end
