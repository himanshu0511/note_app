class RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, only: [:initialize_user_details, :new, :create, :cancel ]
  prepend_before_filter :authenticate_scope!, only: [:edit, :update, :destroy ]

  def initialize_user_details
    confirmation_token = params.delete(:confirmation_token)
    confirmation_token_digest = Devise.token_generator.digest(self, :confirmation_token, confirmation_token)
    self.resource = resource_class.find_by_confirmation_token(confirmation_token_digest)
    yield resource if block_given?
    unless resource.blank?
      resource_email = resource.email
      resource_updated = resource.update_with_password_without_current_password(account_update_params)
      if resource.email != resource_email
        resource.email = resource_email
        resource.save
      end
      yield resource if block_given?
      if resource_updated
        self.resource = resource_class.confirm_by_token(confirmation_token)
        yield resource if block_given?
        if resource.errors.empty?
          sign_in(resource_name, resource, :bypass => true)
          redirect_to root_path
        else
          render :file => 'public/404.html', :status => :not_found, :layout => false
        end
      else
        @confirmation_token = confirmation_token
        render :template => 'devise/registrations/initialize_user_details.html.erb'
      end
    else
      render :file => 'public/404.html', :status => :not_found, :layout => false
    end
  end
end
