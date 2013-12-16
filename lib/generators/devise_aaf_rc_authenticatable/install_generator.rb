module DeviseAafRcAuthenticatable
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)
    
    class_option :user_model, :type => :string, :default => "user", :desc => "Model to update"
    class_option :update_model, :type => :boolean, :default => false, :desc => "Update model to change from database_authenticatable to aaf_rc_authenticatable"
    class_option :add_rescue, :type => :boolean, :default => true, :desc => "Update Application Controller with resuce_from for DeviseAafRcAuthenticatable::AafRcException"
    class_option :advanced, :type => :boolean, :desc => "Add advanced config options to the devise initializer"
    
    
    def create_aaf_rc_config
      copy_file "aaf_rc.yml", "config/aaf_rc.yml"
    end

    def copy_locale
      copy_file "../../../../config/locales/en.yml", "config/locales/devise_aaf_rc.en.yml"
    end
    
    def create_default_devise_settings
      inject_into_file "config/initializers/devise.rb", default_devise_settings, :after => "Devise.setup do |config|\n"   
    end
    
    def update_user_model
      gsub_file "app/models/#{options.user_model}.rb", /:database_authenticatable/, ":aaf_rc_authenticatable" if options.update_model?
    end
    
    def update_application_controller
      inject_into_class "app/controllers/application_controller.rb", ApplicationController, rescue_from_exception if options.add_rescue?
    end
    
    private
    
    def default_devise_settings
      settings = <<-eof
  # ==> AAF Rapid Connect Configuration
  # config.aaf_rc_logger = true
  # config.aaf_rc_create_user = false
  # config.aaf_rc_config = "\#{Rails.root}/config/aaf_rc.yml"

      eof
      if options.advanced?  
        settings << <<-eof  
  # ==> Advanced AAF Rapid Connect Configuration
  
        eof
      end
      
      settings
    end
    
    def rescue_from_exception
      <<-eof
  rescue_from DeviseAafRcAuthenticatable::AafRcException do |exception|
    render :text => exception, :status => 500
  end
      eof
    end
    
  end
end
