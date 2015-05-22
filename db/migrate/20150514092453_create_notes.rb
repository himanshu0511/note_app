class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :heading
      t.text :body
      t.references :created_by
      t.integer :accessibility

      t.timestamps
    end
  end
end
