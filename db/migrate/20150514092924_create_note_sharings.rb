class CreateNoteSharings < ActiveRecord::Migration
  def change
    create_table :note_sharings do |t|
      t.reference :user
      t.reference :note

      t.timestamps
    end
  end
end
