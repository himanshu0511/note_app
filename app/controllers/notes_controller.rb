class NotesController < ApplicationController
  layout 'notes'
  # GET /notes
  # GET /notes.json
  before_filter :authorize_display, :only => [:show]
  before_filter :authorize_update, :only => [:edit, :update]
  before_filter :authorize_destroy, :only => [:destroy]
  before_filter :authorize_destroy_shared_user, :only => [:destroy_shared_user]

  PER_PAGE = 8
  TRUNCATE_TO_LENGTH = 50

  def index
    @note = Note.new
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notes }
    end
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @note }
    end
  end

  # GET /notes/1/edit
  def edit
    @shared_users = User.note_shared_with(@note)
    respond_to do |format|
      format.html # edit.html.erb
    end
  end

  # POST /notes
  # POST /notes.json
  def create
    notes_params = params[:note]
    @note = Note.new(notes_params)
    @note.created_by_id = current_user.id

    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: 'Note was successfully created.' }
        format.json { render json: @note, status: :created, location: @note }
      else
        format.html { render action: "new" }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /notes/1
  # PUT /notes/1.json
  def update
    respond_to do |format|
      if @note.update_attributes(params[:note])
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy

    respond_to do |format|
      format.html { redirect_to notes_url }
      format.json { head :no_content }
    end
  end

  def destroy_shared_user
    note_sharing = NoteSharing.find_by_user_id_and_note_id(params[:user_id], params[:note_id])
    note_sharing.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def user_note_list
    unless params.has_key?(:filter)
      @selected_filter_option = Note::ALL
    else
      @selected_filter_option = params[:filter].to_i
    end
    @truncate_to_length = TRUNCATE_TO_LENGTH
    page_to_display = params.has_key?(:page) ? params[:page] : 1
    @notes = Note.filter(current_user, @selected_filter_option).paginate(:per_page => PER_PAGE, :page => page_to_display)
    respond_to do |format|
      format.html { render :partial => 'note_list' }
      format.json { render json: @notes }
    end
  end

  protected
  def authorize_display
    @note = Note.find(params[:id])
    unless (
    @note.is_public? ||
        current_user.id == @note.created_by_id ||
        NoteSharing.where(:note_id => @note.id, :user_id => current_user.id).count() > 0
    )
      render :file => 'public/404.html', :status => :not_found, :layout => false
    end
  end

  def authorize_update
    @note = Note.find(params[:id])
    unless (
    current_user.id == @note.created_by_id ||
        NoteSharing.where(:note_id => @note.id, :user_id => current_user.id).count() > 0
    )
      render :file => 'public/404.html', :status => :not_found, :layout => false
    end
  end

  def authorize_destroy
    @note = Note.find(params[:id])
    unless current_user.id == @note.created_by_id
      render :file => 'public/404.html', :status => :not_found, :layout => false
    end
  end

  def authorize_destroy_shared_user
    @note = Note.find(params[:note_id])
    unless current_user.id == @note.created_by_id
      render :file => 'public/404.html', :status => :not_found, :layout => false
    end
  end
end
