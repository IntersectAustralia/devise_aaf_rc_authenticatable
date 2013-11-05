require 'devise/strategies/authenticatable'
require 'json'
require 'json/jwt'

module Devise
  module Strategies
    class AafRcAuthenticatable < Authenticatable

      def valid?
        params["assertion"].present? || session["jwt"].present?
      end


      def authenticate!

        jws = params["assertion"]

        if jws
          begin

            config = YAML.load(ERB.new(File.read(::Devise.aaf_rc_config || "#{Rails.root}/config/aaf_rc.yml")).result)[Rails.env]

            jwt = JSON::JWT.decode(jws.to_s, config['secret_token'])
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

        resource = mapping.to.authenticate_with_aaf_rc(session[:attributes])

        if validate(resource)
          resource.after_aaf_rc_authentication
          success!(resource)
        elsif !halted?
          fail(:invalid)
        end
      end
    end
  end
end

Warden::Strategies.add(:aaf_rc_authenticatable, Devise::Strategies::AafRcAuthenticatable)
