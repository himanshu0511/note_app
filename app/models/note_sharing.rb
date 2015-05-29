class NoteSharing < ActiveRecord::Base
  attr_accessible :note, :user
  belongs_to :notes
  belongs_to :users

  # returns note shared between user created the note and the user to which note is share
  scope :notes_shared, lambda{ |creator, shared_to| where(
                         :note_id => Note.where(:created_by_id => creator.id), :user_id => shared_to.id
                     )}
end
