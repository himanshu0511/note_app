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

  has_many :subscribers, :class_name => 'Subscription',
      :foreign_key => 'suscriber_id'
  has_many :subscribed_from, :class_name => 'Subscription',
      :foreign_key => 'subscribed_from_id'
  has_many :shared_notes, :through => 'NoteSharing'
           #:foreign_key => 'note_id'
  has_many :notes, :class_name => 'Note',
      :foreign_key => 'created_by_id'
  has_many :note_sharings, :class_name => 'NoteSharing', :foreign_key => 'user_id'

  validates :email, :presence => true

  validates_uniqueness_of :email
  validates_format_of     :email, with: email_regexp

  validates_confirmation_of :password
  validates_length_of       :password, within: password_length, allow_blank: true

  scope :note_shared_with, lambda {|note_id| joins(:note_sharings).where(:note_id => note_id)}

  def self.validate_email_list(current_user, email_list_string)
    valid_email_list = []
    invalid_format_email_list = []
    not_existing_email_list = []
    user_email_id_included = false
    email_list_string.split(',').each do|email|
      email = email.strip
      unless @@email_regexp.match(email).nil?
        if email == current_user.email
          user_email_id_included = true
        else
          valid_email_list.append(email)
        end
      else
        invalid_format_email_list.append(email)
      end
    end
    valid_user_list = User.select(
        '`email`, `full_name`').where("`email` IN (?) and `confirmed_at` IS NOT NULL", valid_email_list)
    existing_email_set = Set.new(valid_user_list.map { |user| user.email })
    valid_email_list.each do |email|
      unless existing_email_set.member?(email)
        not_existing_email_list.append(email)
      end
    end
    {
        :invalid_format_email_list => invalid_format_email_list,
        :valid_user_list => valid_user_list,
        :not_existing_email_list => not_existing_email_list,
        :current_user_email_id_included => user_email_id_included
    }
  end

  def update_with_password_first_time(params, *options)
    params_valid = true

    if params[:password].blank?
      self.errors.add(:password, :blank)
      params_valid = false
    end
    if params_valid and params[:password_confirmation].blank?
      self.errors.add(:password_confirmation, :blank)
      params_valid = false
    end
    if not params_valid
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
