ThinkingSphinx::Index.define :user, :with => :active_record do
  indexes full_name
end