class PasswordsController < Devise::PasswordsController
  prepend_before_filter :require_no_authentication, :only => [:new, :set_forgotten_password]

  # Render the #edit only if coming from a reset password email link
  append_before_filter :assert_reset_token_passed, :only => [:set_forgotten_password]
  
  def edit
    self.resource = current_user
    respond_to do |format|
      format.html{ render :partial => 'devise/passwords/edit_password' }
    end
  end

  def update
    self.resource = current_user
    respond_to do |format|
      if self.resource.update_with_password(params[:user])
        sign_in(resource_name, resource, :bypass => true)
        format.html { render :nothing => true, :status => :ok }
      else
        format.html { render :partial => 'devise/passwords/edit_password' }
      end
    end
  end
end