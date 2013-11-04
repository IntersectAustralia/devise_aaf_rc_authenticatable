class Devise::AafRcSessionsController < Devise::SessionsController
  unloadable
  
  def aaf_new
    require 'json'
    require 'json/jwt'
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

          #callback method
          redirect_to root_path

        else
          halt 500, "Audience or timings are invalid"
        end
      rescue Exception => e
        halt 500, "Signature was invalid or JWT was otherwise erronous"
      end
    else
      halt 500, "JWS was not found in request"
    end
  end

  def destroy
    session.delete(:attributes)
    session.delete(:jwt)
    super
  end

end
