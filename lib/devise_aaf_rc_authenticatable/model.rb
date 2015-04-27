require 'devise_aaf_rc_authenticatable/strategy'

module Devise
  module Models
    module AafRcAuthenticatable
      extend ActiveSupport::Concern

      # Need to determine why these need to be included
      included do
        attr_reader :password, :current_password
        attr_accessor :password_confirmation
      end

      def update_with_password(params={})
        params.delete(:current_password)
        self.update_without_password(params)
      end

      def update_without_password(params={})
        params.delete(:password)
        params.delete(:password_confirmation)

        result = update_attributes(params)
        result
      end

      # Hook called after AAF authentication.
      def after_aaf_rc_authentication
      end

      module ClassMethods

        def authenticate_with_aaf_rc(attributes={})

          auth_key = self.authentication_keys.first

          auth_key_value = (self.case_insensitive_keys || []).include?(auth_key) ? attributes['mail'].downcase : attributes['mail']

          resource = find_for_authentication(auth_key => auth_key_value)

          if (resource.nil? && !Devise.aaf_rc_create_user)
            Rails.logger.info("User(#{auth_key_value}) not found.  Not configured to create the user.")
            return nil
          end

          if (resource.nil? && Devise.aaf_rc_create_user)
            Rails.logger.info("Creating user(#{auth_key_value}).")
            resource = new
            save_user_aaf_rc_attributes(resource, attributes)
            resource.aaf_rc_before_save if resource.respond_to?(:aaf_rc_before_save)
            resource.save
          end

          resource
        end

        private
        def save_user_aaf_rc_attributes(resource, attributes)
          config = YAML.load(ERB.new(File.read(::Devise.aaf_rc_config || "#{Rails.root}/config/aaf_rc.yml")).result)[Rails.env]
          config['user-mapping'].each do |aaf_attr, db_field|
            Rails.logger.info("Saving #{attributes[aaf_attr]} to #{db_field}")
            field = "#{db_field}="
            value = attributes[aaf_attr]
            resource.send(field, value.to_s) if resource.respond_to?(field)
          end
        end
      end
    end
  end
end
