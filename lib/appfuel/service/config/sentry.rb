module Appfuel
  module Service
    module Config
      def self.sentry_definition
        Appfuel::Configuration.define :sentry do
          validator {
                      required(:dsn).filled(:str?)
                    }
        end
      end
    end
  end
end




