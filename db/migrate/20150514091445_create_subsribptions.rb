class CreateSubsribptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :subscriber
      t.references :subscribed_from

      t.timestamps
    end
    add_index :subscriptions, :subscriber_id
    add_index :subscriptions, :subscribed_from_id
  end
end
