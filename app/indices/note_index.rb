ThinkingSphinx::Index.define :notes, :with => :active_record do
  indexes heading
  indexes body
end