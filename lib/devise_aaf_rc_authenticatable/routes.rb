ActionDispatch::Routing::Mapper.class_eval do
  protected
  
  def devise_aaf_rc_authenticatable(mapping, controllers)
    resource :session, :only => [], :controller => controllers[:aaf_rc_sessions], :path => "" do
      get :aaf_new, :path => mapping.path_names[:aaf_new]
      post :aaf_create, :path => mapping.path_names[:aaf_sign_in]
      get :destroy, :path => mapping.path_names[:aaf_sign_out]
    end

  end
end
