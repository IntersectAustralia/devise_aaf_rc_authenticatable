ActionDispatch::Routing::Mapper.class_eval do
  protected
  
  def devise_aaf_rc_authenticatable(mapping, controllers)
    resource :session, :only => [], :controller => controllers[:aaf_rc_sessions], :path => "" do
      post :new, :path => mapping.path_names[:sign_in], :as => "aaf_new"
      match :destroy, :path => mapping.path_names[:sign_out], :as => "destroy"
    end
  end
end
