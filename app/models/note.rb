class Note < ActiveRecord::Base
  attr_accessible :body, :created_by, :heading, :accessiblity
  has_many :users, :through => 'NoteSharing',
           :foreign_key => 'user_id'
  belongs_to :user, :foreign_key => 'created_by_id'
end
