ThinkingSphinx::Index.define :note, :with => :active_record do
  indexes heading
  indexes body
end