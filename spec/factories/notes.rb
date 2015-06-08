FactoryGirl.define do
  factory :public_note1, :class => Note do
    heading 'note heading user 2'
    body 'note body user 2'
    accessibility Note::PUBLIC_NOTES
  end
  factory :private_note1, :class => Note do
    heading 'shared note heading'
    body 'shared note body'
    accessibility Note::PRIVATE_NOTES
  end
end