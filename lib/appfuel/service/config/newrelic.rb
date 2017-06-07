module Appfuel
  module Service
    module Config
      def self.newrelic_definition
        Appfuel::Configuration.define :newrelic do
          defaults license_key: '',
                   app_name: '',
                   log_level: 'info',
                   monitor_mode: 'true',
                   agent_enabled:'true'
          validator {
            required(:new_relic_license_key).filled(:str?)
            required(:new_relic_app_name).filled(:str?)
            required(:new_relic_log_level).filled(:str?)
            required(:new_relic_monitor_mode).filled(:str?)
            required(:new_relic_agent_enabled).filled(:str?)
          }
        end
      end
    end
  end
end
