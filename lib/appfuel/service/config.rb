require 'yaml'
require_relative 'config/database'
require_relative 'config/sneakers'
require_relative 'config/aws'
require_relative 'config/worker'
require_relative 'config/sentry'
require_relative 'config/newrelic'

module Appfuel
  module Service
    module Config

      def self.configuration(options = {})
        update_definitions(worker_definition,options)
      end

      def self.update_definition(config,options)
        fail 'Options is not a hash' if !options.is_a?(Hash)

        return config if options.empty?

        if options.key?(:defaults)
          fail 'Options is not a hash' if !options[:defaults].is_a?(Hash)
          config.defaults(config.defaults.merge(options[:defaults]))
        end

        if options.key?(:file)
          config.file(options[:file])
        end

        if options.key?(:env)
          fail 'Options is not a hash' if !options[:env].is_a?(Hash)
          config.defaults(config.defaults.merge(options[:env]))
        end

        if options.key?(:exclude)
          options[:exclude].each do |item|
          config.delete(item)
          end
        end

        if options.key?(:children)
          fail 'Options is not a hash' if !options[:children].is_a?(Hash)
          options[:children].each do |key,item|
          update_definition(config[key],item)
          end
        end
        config
      end

    end
  end
end
