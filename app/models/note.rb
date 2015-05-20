class Note < ActiveRecord::Base
  attr_accessible :body, :created_by, :heading, :accessibility
  has_many :users, :through => 'NoteSharing',
           :foreign_key => 'user_id'
  belongs_to :user, :foreign_key => 'created_by_id'
  scope :user_public_notes, lambda { |user| where("created_by_id = ? and accessibility = ?", user.id, @@PUBLIC_NOTES) }
  scope :user_private_notes, lambda { |user| where("created_by_id = ? and accessibility = ?", user.id, @@PRIVATE_NOTES) }
  scope :user_shared_notes, lambda { |user| joins(:note_sharing).where("user_id = ?", user.id)}
  scope :user_suscribed_notes, lambda { |user| joins("INNER JOIN subscription ON note.create_by_id = subscription.suscribed_from_id").where("suscriber_id = ?", user.id)}
  scope :user_all_related_notes, lambda { |user| joins(:note_sharing, "INNER JOIN subscription ON note.create_by_id = subscription.suscribed_from_id").where("suscriber_id = :user_id or note_sharing.user_id = :user_id or created_by = :user_id", {:user_id =>user.id})}
  @@ALL = 1
  @@PUBLIC_NOTES = 2
  @@PRIVATE_NOTES = 3
  @@SHARED_NOTES = 4
  @@SUSCRIBED_NOTES = 5

  @@ACCESSIBILITY_OPTIONS = [
      ['All', @@ALL],
      ['Public Notes', @@PUBLIC_NOTES],
      ['Private Notes', @@PRIVATE_NOTES]
  ]

  @@FILTER_OPTIONS = [
      ['All', @@ALL],
      ['Public Notes', @@PUBLIC_NOTES],
      ['Private Notes', @@PRIVATE_NOTES],
      ['Shared Notes', @@SHARED_NOTES],
      ['Suscribed Notes', @@SUSCRIBED_NOTES]
  ]
  @@filter_to_apply = {
     @@ALL => method(:user_all_related_notes),
     @@PUBLIC_NOTES => method(:user_private_notes),
     @@PRIVATE_NOTES => method(:user_public_notes),
     @@SHARED_NOTES => method(:user_shared_notes),
     @@SUSCRIBED_NOTES => method(:user_suscribed_notes)
  }
  validates_inclusion_of :accessibility, :in => @@ACCESSIBILITY_OPTIONS

  def filter(user, filter)
    @@filter_to_apply[filter].call(user)
  end
end

