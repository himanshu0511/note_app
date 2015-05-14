class User < ActiveRecord::Base
  attr_accessible :full_name
  has_many :suscribers, :class_name => 'Subscription',
      :foreign_key => 'suscriber_id'
  has_many :suscribed_from, :class_name => 'Subscription',
      :foreign_key => 'subscribed_from_id'
  has_many :shared_notes, :through => 'NoteSharing'#,
           #:foreign_key => 'note_id'
  has_many :notes, :class_name => 'Note',
      :foreign_key => 'created_by_id'
end
