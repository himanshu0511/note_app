class NoteSharing < ActiveRecord::Base
  attr_accessible :note, :user
  belongs_to :note, :foreign_key => 'note_id'
  belongs_to :user, :foreign_key => 'user_id'

  # returns note shared between user created the note and the user to which note is share
  scope :notes_shared, lambda{ |creator, shared_to| where(
                         :note_id => Note.where(:created_by_id => creator.id), :user_id => shared_to.id
                     )}
  def self.is_shared_with?(note, user)
    self.where(:note_id => note.id, :user_id => user.id).count > 0
  end
end