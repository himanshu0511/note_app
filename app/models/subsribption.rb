class Subsribption < ActiveRecord::Base
  belongs_to :suscriber, :class_name => 'User'
  belongs_to :suscribed_from, :class_name => 'User'
end
