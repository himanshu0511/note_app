class CreateSubsribptions < ActiveRecord::Migration
  def change
    create_table :subsribptions do |t|
      t.references :suscriber
      t.references :suscribed_from

      t.timestamps
    end
    add_index :subsribptions, :suscriber_id
    add_index :subsribptions, :suscribed_from_id
  end
end
