require 'spec_helper'
RSpec.describe UserProfileController, :type => :controller do
  before(:each) do
    @user = create(:user1)
  end

  after(:each) do
    Warden.test_reset!
  end

  describe 'user_profile success' do
    before(:each) do
      sign_in @user
      @user2 = create(:user2)
    end
    it 'show profile page for logged in user' do
      get :index
      expect(response.status).to eq(200)
    end
    it 'show profile page for logged in user with id' do
      get :show, :id => @user.id
      expect(response.status).to eq(200)
    end
    it 'show profile page of other user' do
      get :show, :id => @user2.id
      expect(response.status).to eq(200)
    end
  end

  describe 'profile pages unauthenticated access' do
    it 'unauthorized access to profile page' do
      get :index
      expect(response.status).to eq(302)
    end
    it 'unauthorized access to profile page with id' do
      get :show, :id => @user.id
      expect(response.status).to eq(302)
    end
  end
end