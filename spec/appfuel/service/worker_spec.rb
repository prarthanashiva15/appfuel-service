module Appfuel::Service
  RSpec.describe Worker do
    context 'Behavior dependencies' do
      it 'has the Appfuel::Application::AppContainer mixin' do
        expect(Worker).to be < Appfuel::Application::AppContainer
      end

      it 'has the Appfuel::Application::Dispatcher mixin' do
        expect(Worker).to be < Appfuel::Application::Dispatcher
      end

      it 'has the Sneaker::Worker mixin' do
        expect(Worker).to be < ::Sneakers::Worker
      end
    end

    context '#work_with_params' do
      it 'dispatches a request with its application container' do
        worker = create_worker

        msg = ''
        delivery_info = double('some rabbitmq delivery')
        properties = double('some rabbitmq properties')

        container = double('some container')
        request = double('some message request')
        response = double('some response')

        allow(request).to receive(:rpc?).with(no_args) { false }
        allow(worker).to receive(:app_container).with(no_args) { container }

        allow(Appfuel::Service::MsgRequest).to(
          receive(:new).with(msg, delivery_info, properties)
        ) { request }

        expect(worker).to(
          receive(:dispatch).with(request, container)
        ) { response }

        expect(worker).to receive(:ack!).with(no_args)

        result = worker.work_with_params(msg, delivery_info, properties)
        expect(result).to eq(response)
      end

      it 'publishes an rpc response' do
        worker = create_worker

        msg = ''
        delivery_info = double('some rabbitmq delivery')
        properties = double('some rabbitmq properties')

        container = double('some container')
        request = double('some message request')
        response = double('some response')

        allow(request).to receive(:rpc?).with(no_args) { true }
        allow(worker).to receive(:app_container).with(no_args) { container }

        allow(Appfuel::Service::MsgRequest).to(
          receive(:new).with(msg, delivery_info, properties)
        ) { request }

        expect(worker).to(
          receive(:dispatch).with(request, container)
        ) { response }


        expect(worker).to receive(:publish_rpc).with(request, response)

        worker.work_with_params(msg, delivery_info, properties)
      end
    end

    def create_worker
      Worker.new
    end

  end
end
