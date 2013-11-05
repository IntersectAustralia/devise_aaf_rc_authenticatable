class Devise::AafRcSessionsController < Devise::SessionsController
  unloadable
  prepend_before_filter :require_no_authentication, :only => [ :aaf_new]
  prepend_before_filter :allow_params_authentication!, :only => :aaf_create
  before_filter :authenticate_user!

  def aaf_new
    config = YAML.load(ERB.new(File.read(::Devise.aaf_rc_config || "#{Rails.root}/config/aaf_rc.yml")).result)[Rails.env]

    redirect_to config['aaf_rc_login_url']
  end

  def aaf_create
    #the authentication is taken care of by the strategy
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
        puts e.message
        #TODO raise devise authentication error
        #halt 500, "Signature was invalid or JWT was otherwise erroneous"
      end
    else
      #TODO raise devise authentication error
      #halt 500, "JWS was not found in request"
    end

    redirect_to root_path
  end

  def destroy
    session.delete(:attributes)
    session.delete(:jwt)
    super
  end

  def extra_validations(attributes)
    false
  end

end
