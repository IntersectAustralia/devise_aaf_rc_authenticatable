class Devise::AafRcSessionsController < Devise::SessionsController
  unloadable
  
  def new
    resource = build_resource
    config = YAML.load(ERB.new(File.read(::Devise.aaf_rc_config || "#{Rails.root}/config/aaf_rc.yml")).result)[Rails.env]


    redirect_to(shib_login_url)
  end

  def destroy
    #clear sessions
    super
  end

end
