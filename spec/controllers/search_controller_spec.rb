require 'spec_helper'
RSpec.describe SearchController, :type => :controller do
  before(:each) do
    @user = create(:user1)
  end

  after(:each) do
    Warden.test_reset!
  end

  describe 'search controller success' do
    before(:each) do
      sign_in @user
    end
    it 'auto complete success' do
      get :search_autocomplete, {search_string: '#{@user.full_name}'}
      expect(response.status).to eq(200)
    end
    it 'search details success' do
      get :detailed_search_results, :search_string => @user.full_name
      expect(response.status).to eq(200)
    end
  end

  describe 'profile pages unauthenticated access' do
    it 'unauthorized access to autocomplete' do
      get :search_autocomplete, {search_string: '#{@user.full_name}'}
      expect(response.status).to eq(302)
    end
    it 'unauthorized access to search details' do
      get :detailed_search_results, {search_string: '#{@user.full_name}'}
      expect(response.status).to eq(302)
    end
  end
end