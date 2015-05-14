class Subscription < ActiveRecord::Base
  attr_accessible :subscriber, :subscribed_from
  belongs_to :subscriber, :class_name => 'User'
  belongs_to :subscribed_from, :class_name => 'User'
end
