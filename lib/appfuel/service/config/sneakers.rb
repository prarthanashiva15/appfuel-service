 module Appfuel
   module Service
    module Config
      #
      # Defines how to parse and validate configuration data for sneakers
      # for more information of the configuration please go to the wiki for
      # the sneakers project https://github.com/jondot/sneakers/wiki/Configuration
      #
      # Configuration Overview:
      #   heartbeat:         RabbitMQ   heartbeat delay in seconds
      #   ack:               RabbitMQ   the worker must acknowledge work is done
      #   daemonize:         Sneakers   deameonize the worker
      #   log                Sneakers   log file location
      #   pid_path           Sneakers   daemon's pidfile location
      #   workers            Sneakers   the number of worker processes
      #   threads            Sneakers   number of threads per worker
      #   prefetch           RabbitMQ   how many messages to send to a worker
      #   timeout_job_after  Sneakers   Maximal seconds to wait for job
      #   start_worker_delay Sneakers   Delay between thread startup
      #   durable            RabbitMQ   Queue should persist
      #   exchange           RabbitMQ   name of the exchange
      #   exchange_type      RabbitMQ   type of exchange (direct, topic, fanout)
      #   vhost              RabbitMQ   name of the vhost
      #   amqp               RabbitMQ   connection string used to communicate
      #
      #   @returns Config::Definition
      def self.sneakers_definition
        Appfuel::Configuration.define :sneakers do
          defaults heartbeat: 60,
                  ack: true,
                  daemonize: true,
                  workers: 1,
                  threads: 1,
                  prefetch: 1,
                  timeout_job_after: 5,
                  durable: true

          validator {
            required(:amqp).filled(:str?)
            required(:vhost).filled(:str?)
            required(:exchange).filled(:str?)
            required(:exchange_type).filled(:str?)
            required(:durable).filled(:bool?)
            required(:ack).filled(:bool?)
            required(:daemonize).filled(:bool?)
            required(:heartbeat).filled(:int?)
            required(:log).filled(:str?)
            required(:pid_path).filled(:str?)
            required(:threads).filled(:int?)
            required(:workers).filled(:int?)
            required(:timeout_job_after).filled(:int?)
            required(:prefetch).filled(:int?)
          }
        end
      end
    end
  end
end
