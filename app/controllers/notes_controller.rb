class NotesController < ApplicationController
  layout 'notes'
  # GET /notes
  # GET /notes.json
  before_filter :to_show_note, :only => [:show]
  before_filter :authorize, :only => [:edit, :update, :destroy]

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
    respond_to do |format|
      format.html # edit.html.erb
    end
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = Note.new(params[:note])
    @note.created_by_id = current_user.id
    # TODO: Add logic to set sharing options of this note

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

  def user_note_list
    if not params.has_key?(:filter)
      @selected_filter_option = Note::ALL
    else
      @selected_filter_option = params[:filter].to_i
    end
    @notes = Note.filter(current_user, @selected_filter_option)
    respond_to do |format|
      format.html { render :partial => 'note_list' }
      format.json { render json: @notes }
    end
  end

  protected
  def to_show_note
    @note = Note.find(params[:id])
    unless (
      @note.is_public? ||
        current_user.id == @note.created_by_id ||
        NoteSharing.where(:note_id => @note.id, :user_id => current_user.id).count() > 0
    )
      render :file => 'public/404.html', :status => :not_found, :layout => false
    end
  end

  def authorize
    if params.has_key?(:id)
      @note = Note.find(params[:id])
      unless current_user.id == @note.created_by_id
        render :file => 'public/404.html', :status => :not_found, :layout => false
      end
    end
  end
end
