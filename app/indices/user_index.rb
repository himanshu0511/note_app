ThinkingSphinx::Index.define :users, :with => :active_record do
  indexes full_name
end