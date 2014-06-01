class CreateFeedItemForwadings < ActiveRecord::Migration
  def change
    create_table :feed_item_forwadings do |t|

      t.references :feed_item
      t.string :to_org_id
      t.string :to_user_id, null: false
      t.string :fowarding_feed_id, null: false
      t.boolean :is_replied, default: false
      t.text :reply_body

      t.timestamps
    end

    add_index :feed_item_forwadings, :to_user_id
    add_index :feed_item_forwadings, :fowarding_feed_id
  end
end
