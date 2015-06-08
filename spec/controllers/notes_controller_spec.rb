require 'spec_helper'
RSpec.describe NotesController, :type => :controller do
  before(:each) do
    @user = create(:user1)
  end

  after(:each) do
    Warden.test_reset!
  end

  describe 'note pages success' do
    before(:each) do
      sign_in @user
    end
    it 'homepage responds successfully' do
      get :index
      expect(response.status).to eq(200)
    end
    it 'new note action responds successfully' do
      get :new
      expect(response.status).to eq(200)
    end
    it 'edit note created by logged in user' do
      @note = create(:private_note1, :created_by_id => @user.id)
      get :edit, :id => @note.id
      expect(response.status).to eq(200)
    end
    it 'show note created by logged in user' do
      @note = create(:private_note1, :created_by_id => @user.id)
      get :show, :id => @note.id
      expect(response.status).to eq(200)
    end
    it 'show public note' do
      @user2 = create(:user2)
      @note = create(:public_note1, :created_by_id => @user2.id)
      get :show, :id => @note.id
      expect(response.status).to eq(200)
    end
    it 'edit note shared to user' do
      @user2 = create(:user2)
      @note = create(:private_note1, :created_by_id => @user2.id)
      @note_sharing = NoteSharing.create(:user => @user, :note => @note)
      get :edit, :id => @note.id
      expect(response.status).to eq(200)
    end
    it 'show note shared to user' do
      @user2 = create(:user2)
      @note = create(:private_note1, :created_by_id => @user2.id)
      @note_sharing = NoteSharing.create(:user=> @user, :note => @note)
      get :show, :id => @note.id
    end
  end

  describe 'note update, create, delete requests success' do
    before(:each) do
      sign_in @user
    end
    it 'new note to created successfully ' do
      post :create, {:note => attributes_for(:private_note1)}
      expect(response.status).to eq(302)
    end
    it 'edit note to created successfully ' do
      @note = create(:private_note1, :created_by_id => @user.id)
      post :create, {:note => attributes_for(:private_note1, :heading => 'new heading')}
      expect(response.status).to eq(302)
    end
    it 'edit note shared to user' do
      @user2 = create(:user2)
      @note = create(:private_note1, :created_by_id => @user2.id)
      @note_sharing = NoteSharing.create(:user => @user, :note => @note)
      post :create, {:note => attributes_for(:private_note1, :heading => 'new heading')}
      expect(response.status).to eq(302)
    end
    it 'delete created note by current user' do
      @note = create(:private_note1, :created_by_id => @user.id)
      delete :destroy, :id => @note.id
      expect(response.status).to eq(302)
    end
  end

  describe 'note update, create, delete requests failure' do
    before(:each) do
      sign_in @user
    end
    it 'new note creation failed for missing heading' do
      post :create, {:note => attributes_for(:private_note1, :heading => nil)}
      expect(response.status).to eq(200)
    end
    it 'new note creation failed for missing body' do
      post :create, {:note => attributes_for(:private_note1, :body => nil)}
      expect(response.status).to eq(200)
    end
    it 'update failed for missing heading' do
      @note = create(:private_note1, :created_by_id => @user.id)
      put :update, {:id => @note.id, :note => attributes_for(:private_note1, :heading => nil)}
      expect(response.status).to eq(200)
    end
    it 'update failed for missing body' do
      @note = create(:private_note1, :created_by_id => @user.id)
      put :update, {:id => @note.id, :note => attributes_for(:private_note1, :body=> nil)}
      expect(response.status).to eq(200)
    end
    it 'update failed for unauthorized user' do
      @user2 = create(:user2)
      @note = create(:private_note1, :created_by_id => @user2.id)
      put :update, {:id => @note.id, :note => attributes_for(:private_note1, :heading => nil)}
      expect(response.status).to eq(403)
    end
    it 'delete created note by current user' do
      @user2 = create(:user2)
      @note = create(:private_note1, :created_by_id => @user2.id)
      delete :destroy, :id => @note.id
      expect(response.status).to eq(403)
    end
  end

  describe 'note pages unauthenticated access' do
    it 'homepage redirect' do
      get :index
      expect(response.status).to eq(302)
    end
    it 'new note redirect' do
      get :new
      expect(response.status).to eq(302)
    end
    it 'edit note redirect' do
      @note = create(:private_note1, :created_by_id => @user.id)
      get :edit, :id => @note.id
      expect(response.status).to eq(302)
    end
    it 'show note redirect' do
      @note = create(:private_note1, :created_by_id => @user.id)
      get :show, :id => @note.id
      expect(response.status).to eq(302)
    end
  end
  describe 'note page forbidden access' do
    before(:each) do
      sign_in @user
    end
    it 'edit note shared to user' do
      @user2 = create(:user2)
      @note = create(:private_note1, :created_by_id => @user2.id)
      get :edit, :id => @note.id
      expect(response.status).to eq(403)
    end
    it 'show note shared to user' do
      @user2 = create(:user2)
      @note = create(:private_note1, :created_by_id => @user2.id)
      get :show, :id => @note.id
      expect(response.status).to eq(403)
    end
  end
end