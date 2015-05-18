class RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, only: [ :new, :create, :cancel ]
  prepend_before_filter :authenticate_scope!, only: [:edit, :update, :destroy ]

  def sign_up(resource_name, resource)
    binding.pry
    User.send_confirmation_instructions(resource.email)
  end
end