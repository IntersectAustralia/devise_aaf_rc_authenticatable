require 'devise/strategies/authenticatable'
require 'json'
require 'json/jwt'

module Devise
  module Strategies
    class AafRcAuthenticatable < Authenticatable
      def valid?
        valid_for_aaf_rc_auth?
      end

      def authenticate!
        if resource = mapping.to.authenticate_with_aaf(session[:attributes])
          if resource.active_for_authentication?
            success!(resource, :signed_in)
          else
            fail!(:inactive)
          end
        else
	        fail!(:invalid)
        end
      end

      def valid_for_aaf_rc_auth?

        jws = params[:assertion]

        if jws
          begin

            config = YAML.load(ERB.new(File.read(::Devise.aaf_rc_config || "#{Rails.root}/config/aaf_rc.yml")).result)[Rails.env]

            jwt = JSON::JWT.decode(jws.to_s, config['server_token'])
            aaf_host = config['aaf_rc_login_url'][/^https:\/\/[\w\.]+/] if config['aaf_rc_login_url']
            aaf_host ||= "https://rapid.aaf.edu.au"

            # In a complete app we'd also store and validate the jti value to ensure there is no replay attack
            if jwt['iss'] == aaf_host && jwt['aud'] == config['hostname'] && Time.now > Time.at(jwt['nbf']) && Time.now < Time.at(jwt['exp'])
              attributes = jwt['https://aaf.edu.au/attributes']
              session[:attributes] = attributes
              session[:jwt] = jwt
            else
              #TODO raise devise authentication error
              #halt 500, "Audience or timings are invalid"
            end
          rescue Exception => e
            #TODO raise devise authentication error
            #halt 500, "Signature was invalid or JWT was otherwise erroneous"
          end
        else
          #TODO raise devise authentication error
          #halt 500, "JWS was not found in request"
        end

        # only try and authenticate if the AAF POST parameters are present
        jws.present? && session[:attributes].present?
      end
    end
  end
end

Warden::Strategies.add(:aaf_rc_authenticatable, Devise::Strategies::AafRcAuthenticatable)
