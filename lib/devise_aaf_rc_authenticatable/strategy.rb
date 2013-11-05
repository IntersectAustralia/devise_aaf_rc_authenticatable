require 'devise/strategies/authenticatable'
require 'json'
require 'json/jwt'

module Devise
  module Strategies
    class AafRcAuthenticatable < Authenticatable
      def valid?
        session['jwt'].present?
      end

      def authenticate!
        if resource = mapping.to.authenticate_with_aaf_rc(session[:attributes])
          if resource.active_for_authentication?
            success!(resource, :signed_in)
          else
            fail!(:inactive)
          end
        else
	        fail!(:invalid)
        end
      end
    end
  end
end

Warden::Strategies.add(:aaf_rc_authenticatable, Devise::Strategies::AafRcAuthenticatable)
