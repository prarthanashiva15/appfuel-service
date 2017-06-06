module Appfuel::Service
  RSpec.describe MsgRequest do
    it 'is a Appfuel::Request' do
      expect(MsgRequest).to be < Appfuel::Request
    end

    context '#initialize' do
      it 'converts inputs as an empty string to a hash' do
        delivery_info = double('some delivery info')
        properties    = double('some properties')

        allow_action_route(properties, 'foo/bar')

        request  = create_request('', delivery_info, properties)

        expect(request.inputs).to eq({})
        expect(request.properties).to eq(properties)
        expect(request.delivery_info).to eq(delivery_info)
        expect(request.namespace).to eq('features.foo.actions.bar')
      end
    end

    context '#reply_to' do
      it 'delegates reply_to to properties' do
        delivery_info = double('some delivery info')
        properties    = double('some properties')
        allow_action_route(properties, 'foo/bar')

        reply_to = 'some_reply_queue'
        allow(properties).to receive(:reply_to).with(no_args) { reply_to }

        request = create_request('', delivery_info, properties)
        expect(request.reply_to).to eq(reply_to)
      end
    end

    context '#correlation_id' do
      it 'delegates correlation_id to properties' do
        delivery_info = double('some delivery info')
        properties    = double('some properties')
        id = 'some_correlation_id'

        allow_action_route(properties, 'foo/bar')
        allow(properties).to receive(:correlation_id).with(no_args) { id }

        request = create_request('', delivery_info, properties)
        expect(request.correlation_id).to eq(id)
      end
    end

    context '#rpc?' do
      it 'returns true a correlation_id and reply_to is set' do

        delivery_info = double('some delivery info')
        properties    = double('some properties')
        id = 'some_correlation_id'
        reply_to = 'some_reply_queue'

        allow_action_route(properties, 'foo/bar')
        allow(properties).to receive(:correlation_id).with(no_args) { id }
        allow(properties).to receive(:reply_to).with(no_args) { reply_to }

        request = create_request('', delivery_info, properties)
        expect(request.rpc?).to be(true)
      end

      it 'returns false when no reply_to or correlation_id' do
        delivery_info = double('some delivery info')
        properties    = double('some properties')

        allow_action_route(properties, 'foo/bar')
        allow(properties).to receive(:correlation_id).with(no_args) { nil }
        allow(properties).to receive(:reply_to).with(no_args) { nil }

        request = create_request('', delivery_info, properties)
        expect(request.rpc?).to be(false)
      end
    end


    def allow_action_route(properties, route)
      headers = {'action_route' => route}
      allow(properties).to receive(:headers).with(no_args) { headers }
    end

    def create_request(msg, delivery_info, properties)
      MsgRequest.new(msg, delivery_info, properties)
    end

  end
end
