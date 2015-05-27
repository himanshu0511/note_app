class NotesController < ApplicationController
  layout 'notes'
  # GET /notes
  # GET /notes.json
  before_filter :authorize_display, :only => [:show]
  before_filter :authorize_update, :only => [:edit, :update]
  before_filter :authorize_destroy, :only => [:destroy]

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

  def generate_error_messages_for_sharing_options(response)
    error = {
        :count => 0,
        :full_messages => {
            :invalid_format => nil,
            :not_existing_email => nil,
            :self_included => nil
        }
    }
    unless response[:invalid_format_email_list].any?
      error[:count] += 1
      error[:full_messages][:invalid_format] = "Invalid format for ?", response[:invalid_format_email_list].join(', ')
    end
    unless response[:not_existing_email_list].any?
      error[:count] += 1
      error[:full_messages][:not_existing_email] = "Not existing emails ?", response[:not_existing_email_list].join(', ')
    end
    unless response[:current_user_email_id_included]
      error[:count] += 1
      error[:full_messages][:self_included] = "Should not include your own email id ?", current_user.email
    end
    error
  end

  def validate_sharing_list
    # response contains data with keys
    # :invalid_format_email_list, :valid_user_list , :not_existing_email_list, current_user_email_id_included,
    # and :current_user_email
    @response = User.validate_email_list(current_user, params[:share_with])
    respond_to do |format|
      format.html {
        @sharing_option_errors = generate_error_messages_for_sharing_options(@response)
        render :partial => 'note_sharing_and_accessibility'
      }
      format.json { render json: @response }
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
end
