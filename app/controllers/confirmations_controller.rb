class ConfirmationsController < Devise::ConfirmationsController
 # GET /resource/confirmation?confirmation_token=abcdef
  def show
    confirmation_token = Devise.token_generator.digest(self, :confirmation_token, params[:confirmation_token])
    self.resource = resource_class.find_by_confirmation_token(confirmation_token)
    yield resource if block_given?

    unless resource.blank?
      @confirmation_token = params[:confirmation_token]
      render :template => 'devise/registrations/initialize_user_details.html.erb'
    else
      render :file => 'public/404.html', :status => :not_found, :layout => false
    end
  end
end
