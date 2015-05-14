class Note < ActiveRecord::Base
  attr_accessible :body, :created_by, :heading, :type
end
