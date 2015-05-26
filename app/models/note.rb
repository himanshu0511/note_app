class Note < ActiveRecord::Base
  attr_accessible :body, :created_by, :heading, :accessibility
  has_many :users, :through => 'NoteSharing',
           :foreign_key => 'user_id'
  has_many :note_sharings, :class_name => 'NoteSharing', :foreign_key => 'note_id'
  belongs_to :user, :foreign_key => 'created_by_id'
  after_initialize :init

  def init
    # reference: http://stackoverflow.com/questions/328525/how-can-i-set-default-values-in-activerecord
    self.accessibility = PRIVATE_NOTES if (self.has_attribute? :accessibility) && self.accessibility.nil?
  end

  scope :distinct, select("DISTINCT(`notes`.`id`), `notes`.*")
  scope :user_public_notes, lambda { |user| where("created_by_id = ? and accessibility = ?", user.id, PUBLIC_NOTES)}
  scope :user_private_notes, lambda { |user| where("created_by_id = ? and accessibility = ?", user.id, PRIVATE_NOTES)}
  scope :user_shared_notes, lambda { |user| joins("LEFT JOIN `note_sharings` ON `note_sharings`.`note_id` = `notes`.`id`").where("user_id = ?", user.id)}
  scope :user_subscribed_notes, lambda { |user| joins(
                                  "LEFT JOIN `subscriptions` ON `notes`.`created_by_id` = `subscriptions`.`subscribed_from_id`"
                              ).where("subscriber_id = ? and `notes`.`accessibility` = ?", user.id, PUBLIC_NOTES)}
  scope :user_all_related_notes, lambda { |user| joins(
                                   "LEFT JOIN `note_sharings` ON `note_sharings`.`note_id` = `notes`.`id`",
                                   "LEFT JOIN `subscriptions` ON `notes`.`created_by_id` = `subscriptions`.`subscribed_from_id`"
                               ).where(
                                   '`subscriptions`.`subscriber_id` = :user_id and `notes`.`accessibility` = :accessibility or `note_sharings`.`user_id` = :user_id or `notes`.`created_by_id` = :user_id',
                                   {
                                       :user_id => user.id,
                                       :accessibility => PUBLIC_NOTES
                                   }
                               ).distinct}

  PUBLIC_NOTES = 1
  PRIVATE_NOTES = 2
  SHARED_NOTES = 3
  SUBSCRIBED_NOTES = 4
  ALL =5

  ACCESSIBILITY_OPTIONS = [
      ['Public Notes', PUBLIC_NOTES],
      ['Private Notes', PRIVATE_NOTES]
  ]

  FILTER_OPTIONS = [
      ['All', ALL],
      ['Public Notes', PUBLIC_NOTES],
      ['Private Notes', PRIVATE_NOTES],
      ['Shared Notes', SHARED_NOTES],
      ['Subscribed Notes', SUBSCRIBED_NOTES]
  ]
  FILTER_TO_APPLY = {
     ALL => method(:user_all_related_notes),
     PUBLIC_NOTES => method(:user_public_notes),
     PRIVATE_NOTES => method(:user_private_notes),
     SHARED_NOTES => method(:user_shared_notes),
     SUBSCRIBED_NOTES => method(:user_subscribed_notes)
  }
  validates_inclusion_of :accessibility, :in => ACCESSIBILITY_OPTIONS.collect{|x| x[1]}, :allow_blank => true

  def self.filter(user, filter)
    FILTER_TO_APPLY[filter].call(user)
  end
  def is_public?
    self.accessibility == PUBLIC_NOTES ? true : false
  end
end