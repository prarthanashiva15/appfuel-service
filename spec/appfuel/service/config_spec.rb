module Appfuel::Service
  RSpec.describe Config do
    it 'returns the config values depending on the options else returns defaults' do
      expect(Config).to be Appfuel::Service::Config
    end

    context '#update_definition' do
      it 'returns the defaults when options is empty' do
        config = Appfuel::Service::Config.worker_definition
        options= {}
        result = Config.update_definition(config,options)
        expect(config).to eq(result)
      end

      it 'returns the new file name when options has a file' do
        config = Appfuel::Service::Config.worker_definition
        options= {
          file:"abc.yaml"
        }
        result = Config.update_definition(config,options)
        expect(result.file).to eq(["abc.yaml"])
      end

      it 'returns the new defaults when options has defaults' do
        config = Appfuel::Service::Config.worker_definition
        options= {
          defaults: {
            logfile: '/foo/bar',
            audit_logfile: '/foo/baz'
          }
        }
        result = Config.update_definition(config,options)
        expect(result.defaults).to eq({
                                        logfile: '/foo/bar',
                                        audit_logfile: '/foo/baz'
                                       })
      end

      it 'excludes the options from the config' do
        config = Appfuel::Service::Config.worker_definition
        options= {exclude: ['aws', 'sentry']}
        result = Config.update_definition(config,options)
        expect(result[:aws]).to eq(nil)
        expect(result[:sentry]).to eq(nil)
      end


      it 'replaces the children defaults with the new defaults in the options' do
        config = Appfuel::Service::Config.worker_definition
        options = {
          children:{
            db:{
               defaults: {path: 'blah/foo'}
            }
          }
        }
        result = Config.update_definition(config,options)
        expect(result[:db].defaults[:path]).to eq('blah/foo')
      end

      it 'fails when we pass a string instead of a hash' do
        config = Appfuel::Service::Config.worker_definition
        options = 'I am a string'
        msg = 'Options is not a hash'
        expect {
          Config.update_definition(config,options)
        }.to raise_error(msg)
      end

      it 'fails when we pass options[:Defaults] as a list instead of a hash' do
        config = Appfuel::Service::Config.worker_definition
        options= {
          defaults:[123,567]
        }
        msg = 'Options is not a hash'
        expect {
          Config.update_definition(config,options)
        }.to raise_error(msg)
      end

      it 'fails when we pass options[:children] as a list instead of a hash' do
        config = Appfuel::Service::Config.worker_definition
        options= {
          children:{
            db:['123,456']
            }
        }
        msg = 'Options is not a hash'
        expect {
          Config.update_definition(config,options)
        }.to raise_error(msg)
      end

    end
  end
end
