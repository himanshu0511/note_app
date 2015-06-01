class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :trackable #:validatable #, :rememberable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :full_name
  mattr_accessor :email_regexp
  @@email_regexp = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  # Range validation for password length
  mattr_accessor :password_length
  @@password_length = 6..128

  SEARCH_RESULT_PARTIAL = 'search/user_partial'

  def get_search_result_partial_path
    SEARCH_RESULT_PARTIAL
  end

  has_many :subscribers, :class_name => 'Subscription',
           :foreign_key => 'subscriber_id'
  has_many :subscribed_from, :class_name => 'Subscription',
           :foreign_key => 'subscribed_from_id'
  has_many :shared_notes, :through => 'NoteSharing'
  #:foreign_key => 'note_id'
  has_many :notes, :class_name => 'Note',
           :foreign_key => 'created_by_id'
  has_many :note_sharings, :class_name => 'NoteSharing', :foreign_key => 'user_id'

  validates :email, :presence => true

  validates_uniqueness_of :email
  validates_format_of :email, with: email_regexp

  validates_confirmation_of :password
  validates_length_of :password, within: password_length, allow_blank: true
  scope :note_shared_with, lambda { |note_id| joins(:note_sharings).where("`note_sharings`.`note_id` = ?", note_id) }

  def self.validate_email_list(current_user_id, email_list_string, note_id=nil)
    valid_email_list = []
    invalid_format_email_list = []
    not_existing_email_list = []
    email_list_string.split(',').each do |email|
      email = email.strip
      unless @@email_regexp.match(email).nil?
        valid_email_list.append(email)
      else
        invalid_format_email_list.append(email)
      end
    end
    unless note_id.nil?
      already_shared_users_ids = Set.new(User.note_shared_with(note_id).pluck(:id))
    end
    valid_user_list = User.select(
        '`id`, `email`, `full_name`'
    ).where("`users`.`email` IN (?) and `users`.`confirmed_at` IS NOT NULL", valid_email_list)
    existing_email_set = Set.new(valid_user_list.map { |user| user.email })
    valid_email_list.each do |email|
      unless existing_email_set.member?(email)
        not_existing_email_list.append(email)
      end
    end

    error = []
    if invalid_format_email_list.any?
      error.append("has invalid format for %s: %s" % [
                       ActionController::Base.helpers.pluralize(invalid_format_email_list.size, "email"),
                       invalid_format_email_list.join(', ')
      ])
    end
    if not_existing_email_list.any?
      error.append("has emails of non existing users: %s" % not_existing_email_list.join(', '))
    end
    current_user = (valid_user_list.select { |user| user.id == current_user_id }).first
    unless current_user.nil?
      error.append("contains your own email id: %s" % current_user.email)
    end
    if error.any?
      {
          :error => error
      }
    else
      {
          :error => [],
          :valid_user_list => already_shared_users_ids.nil? ? valid_user_list : valid_user_list.select {
              |user| not already_shared_users_ids.member?(user.id)
          }
      }
    end
  end

  def update_with_password_without_current_password(params, *options)
    params_valid = true

    if params[:password].blank?
      self.errors.add(:password, :blank)
      params_valid = false
    end
    if params_valid and params[:password_confirmation].blank?
      self.errors.add(:password_confirmation, :blank)
      params_valid = false
    end
    unless params_valid
      params.delete(:password)
      params.delete(:password_confirmation)
      self.assign_attributes(params, *options)
      self.valid?
      false
    end
    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end
end
