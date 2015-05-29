class PasswordsController < Devise::PasswordsController
  prepend_before_filter :require_no_authentication, :only => [:new, :set_forgotten_password]

  # Render the #edit only if coming from a reset password email link
  append_before_filter :assert_reset_token_passed, :only => [:set_forgotten_password]

  def send_forgotten_password_email
    self.resource = User.find_by_email(params["email"])
    self.resource.send_confirmation_instructions

    redirect_to root
  end

  def edit_forgotten_password
    confirmation_token = params.delete(:confirmation_token)
    confirmation_token_digest = Devise.token_generator.digest(self, :confirmation_token, confirmation_token)
    self.resource = resource_class.find_by_confirmation_token(confirmation_token_digest)
    respond_to do |format|
      unless self.resource.nil?
        format.html { render 'devise/passwords/set_forgotten_password' }
      else
        format.html{ render :file => 'public/404.html', :status => :not_found, :layout => false }
      end
    end
  end

  def set_forgotten_password
    confirmation_token = params.delete(:confirmation_token)
    confirmation_token_digest = Devise.token_generator.digest(self, :confirmation_token, confirmation_token)
    self.resource = resource_class.find_by_confirmation_token(confirmation_token_digest)
    respond_to do |format|
      if self.resource.update_with_password_without_current_password(params)
        format.html { redirect_to root }
        format.json { render json self.resource }
      else
        format.html {render :file => 'public/404.html', :status => :not_found, :layout => false}
      end
    end
  end

  def edit
    self.resource = current_user
    respond_to do |format|
      format.html{ render :partial => 'devise/passwords/edit_password' }
    end
  end

  def update
    self.resource = current_user
    yield resource if block_given?
    if self.resource.update_with_password_without_current_password(account_update_params)
      format.html{ render :none}
    else
      format.html{ render :partial => 'devise/passwords/edit_password' }
    end
  end
end