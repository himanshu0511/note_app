class NoteSharing < ActiveRecord::Base
  attr_accessible :note, :user
  belongs_to :notes
  belongs_to :users
end
