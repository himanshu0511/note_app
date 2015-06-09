require 'spec_helper'
RSpec.describe RegistrationsController, :type => :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  after(:each) do
    Warden.test_reset!
  end

  describe 'success' do
    it 'update initial user details' do
      confirmation_token = 'temp_confirmation_token'
      confirmation_token_digest = Devise.token_generator.digest(
          self,
          :confirmation_token,
          confirmation_token
      )
      @user = create(:new_user)
      @user.confirmation_token = confirmation_token_digest
      @user.save
      post :initialize_user_details, {
                                      :confirmation_token => confirmation_token,
                                      :user => {
                                          :email => @user.email,
                                          :full_name => 'temp test name',
                                          :password => 'temp_password',
                                          :password_confirmation => 'temp_password'
                                      }
                                  }
      expect(response.status).to eq(302)
    end
  end

  describe 'failure' do
    it 'update initial user details' do
      confirmation_token = 'temp_confirmation_token'
      confirmation_token_digest = Devise.token_generator.digest(
          self,
          :confirmation_token,
          confirmation_token
      )
      @user = create(:new_user)
      @user.confirmation_token = confirmation_token_digest
      @user.save
      post :initialize_user_details, {
                                      :confirmation_token => confirmation_token,
                                      :user => {
                                          :email => @user.email,
                                          :full_name => nil,
                                          :password => nil,
                                          :password_confirmation => nil
                                      }
                                  }
      expect(response.status).to eq(200)
    end
  end

  describe 'unauthenticated access' do
    it 'update initial user details' do
      confirmation_token = 'temp_confirmation_token'
      @user = create(:new_user)
      post :initialize_user_details, {
                                      :confirmation_token => confirmation_token,
                                      :user => {
                                          :email => @user.email,
                                          :full_name => 'temp test name',
                                          :password => 'temp_password',
                                          :password_confirmation => 'temp_password'
                                      }
                                  }
      expect(response.status).to eq(404)
    end
  end
end