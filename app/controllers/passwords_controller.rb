class PasswordsController < Devise::PasswordsController
  prepend_before_filter :require_no_authentication, :only => :new

  def edit_password
    self.resource = current_user
    respond_to do |format|
      format.html{ render 'devise/passwords/edit_password' }
    end
  end

  def update_password
    self.resource = current_user
    if self.resource.update_with_password(params[:user])
      sign_in(resource_name, resource, :bypass => true)
      redirect_to :controller => 'user_profile', :action => 'index'
    else
      respond_to do |format|
        format.html { render 'devise/passwords/edit_password' }
      end
    end
  end
end