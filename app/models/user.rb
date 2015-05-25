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
  validates :email, :presence => true

  validates_uniqueness_of :email
  validates_format_of     :email, with: email_regexp

  validates_confirmation_of :password
  validates_length_of       :password, within: password_length, allow_blank: true

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
