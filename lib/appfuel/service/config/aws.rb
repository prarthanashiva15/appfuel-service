module Appfuel
  module Service
    module Config
      #
      # Defines how to parse and validate configuration data for aws
      #
      # Configuration Overview:
      #   access_key_id:    access credentials for aws
      #   secret_access_key: access credentials for aws
      #   assets_bucket:    name of bucket to hold assets
      #   documents_buckets  name of bucket to hold documents
      #
      #   @returns Config::Definition
      def self.aws_definition
        Appfuel::Configuration.define :aws do
          defaults region: 'us-west-2'

          validator {
            required(:region).filled(:str?)
            optional(:access_key_id).filled(:str?)
            optional(:secret_access_key).filled(:str?)
            optional(:kms_master_key_id).filled(:str?)
            optional(:kms_data_key_cipher).filled(:str?)
          }
        end
      end
    end
  end
end
