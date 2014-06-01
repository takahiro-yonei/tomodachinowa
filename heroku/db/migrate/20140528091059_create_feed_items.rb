class CreateFeedItems < ActiveRecord::Migration
  def change
    create_table :feed_items do |t|

      t.string :user_id, null: false
      t.string :org_id
      t.string :feed_id, null: false
      t.text :feed_body

      t.timestamps
    end

    add_index :feed_items, :user_id
    add_index :feed_items, :feed_id
  end
end
