class CreateNoteSharings < ActiveRecord::Migration
  def change
    create_table :note_sharings do |t|
      t.references :user
      t.references :note

      t.timestamps
    end
  end
end
