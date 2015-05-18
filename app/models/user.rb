class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :trackable #:validatable #, :rememberable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :full_name
  has_many :suscribers, :class_name => 'Subscription',
      :foreign_key => 'suscriber_id'
  has_many :suscribed_from, :class_name => 'Subscription',
      :foreign_key => 'subscribed_from_id'
  has_many :shared_notes, :through => 'NoteSharing'#,
           #:foreign_key => 'note_id'
  has_many :notes, :class_name => 'Note',
      :foreign_key => 'created_by_id'
  validates :email, :presence => true
end
