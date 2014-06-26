require 'devise/strategies/authenticatable'
require 'json'
require 'json/jwt'

module Devise
  module Strategies
    class AafRcAuthenticatable < Authenticatable

      def valid?
        params["assertion"].present? || (session["jwt"].present? && !session["jwt_unauthorized"].present?)
      end

      def authenticate!
        # params["assertion"] is checked for presence in valid? method.
        jws = params["assertion"]
        if jws
          begin

            config = YAML.load(ERB.new(File.read(::Devise.aaf_rc_config || "#{Rails.root}/config/aaf_rc.yml")).result)[Rails.env]

            jwt = JSON::JWT.decode(jws.to_s, config['secret_token'])
            aaf_host = config['aaf_rc_login_url'][/^https:\/\/[\w\.]+/] if config['aaf_rc_login_url']
            aaf_host ||= "https://rapid.aaf.edu.au"

            # In a complete app we'd also store and validate the jti value to ensure there is no replay attack
            if jwt['iss'] == aaf_host && jwt['aud'] == config['hostname']
              current_time = Time.now
              if current_time > Time.at(jwt['nbf']) && current_time < Time.at(jwt['exp'])
                session[:attributes] = jwt['https://aaf.edu.au/attributes']
                session[:jwt] = jwt
              else
                logger.error(" Timing is invalid. #{current_time} out of range of #{Time.at(jwt['nbf'])} to #{Time.at(jwt['exp'])}")
                return fail(:invalid_timing)
              end
            else
              logger.error(" Audience is invalid. #{jwt['aud']} vs #{config['hostname']}")
              return fail(:invalid_audience)
            end
          rescue Exception => e
            logger.error(" Signature was invalid or JWT was otherwise erroneous. #{e.message}")
            return fail(:invalid_jwt)
          end
        end

        resource = mapping.to.authenticate_with_aaf_rc(session[:attributes])

        if validate(resource)
          begin
            resource.after_aaf_rc_authentication
            session.delete(:jwt_unauthorized)
          rescue Exception
            session["jwt_unauthorized"] = 'Unauthorized'
          end
          success!(resource)
        elsif !halted?
          fail(:invalid)
        end
      end
    end
  end
end

Warden::Strategies.add(:aaf_rc_authenticatable, Devise::Strategies::AafRcAuthenticatable)
