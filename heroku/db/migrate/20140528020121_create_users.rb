class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string :provider, null: false
      t.string :uid, null: false
      t.string :user_id, null: false
      t.string :org_id, null: false
      t.string :nick_name
      t.string :email
      t.string :instance_url, null: false
      t.string :token, null: false, limit: 500
      t.string :refresh_token, null: false, limit: 500

      t.boolean :is_valid, default: true

      t.timestamps
    end

    add_index :users, [:provider, :uid]
    add_index :users, :user_id

  end
end
