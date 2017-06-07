module Appfuel
 module Service
  module Config
    # Defines the configuration for the whole worker. It basically has two
    # child definitions :db and :sneakers
    #
    # Configuration Overview
    #
    # env:        The environement this worker is deployed as dev, qa, stg, prod
    # logfile:    The location of the application log file if the value is
    #             stdout or stderr it will use that instead
    # dispatchers List of workers that dispatch messages to actions. The reason
    #             why you would want more than one is to use different exchange
    #             types
    #
    # db          Database configuration please see sp_offers/config/database
    # sneakers    RabbitMQ configuration please see sp_offers/config/sneakers
    # aws         Configuration S3 where we store our documents
    # @return Definition
    def self.worker_definition
      Appfuel::Configuration.define :worker do
        file 'config/app.yaml'
        defaults logfile: 'stdout',
                  audit_logfile: 'stdout'

        validator {
          required(:env).filled(:str?)
          required(:logfile).filled(:str?)
          required(:audit_logfile).filled(:str?)
          # Children will be validated on there own
          # we are just ensuring they exist
          required(:db).filled(:hash?)
          optional(:sneakers).filled(:hash?)
          optional(:aws).filled(:hash?)
          optional(:sentry).filled(:hash?)
          optional(:newrelic).filled(:hash?)
        }
        self << [
          Config.db_definition,
          Config.sneakers_definition,
          Config.aws_definition,
          Config.sentry_definition,
          Config.newrelic_definition
        ]
     end
   end
  end
 end
end
