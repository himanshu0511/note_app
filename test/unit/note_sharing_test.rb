require 'test_helper'

class NoteSharingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "user and note relation ship" do

    user1 = User.new
    user2 = User.new
    user1.full_name = "test name1"
    user2.full_name = "test name"

    note1 = Note.new
    note2 = Note.new
    note1.heading = "test heading 1"
    note1.body = "test body 1"


    note2.heading = "test heading 2"
    note2.body = "test body 2"


    user1.save
    user2.save
    note1.save

    note2.created_by_id = user2.id
    note2.save

    user1.shared_notes << note2
    user1.save

    assert NoteSharing.where(user_id => user1.id).count == 1
  end
end
