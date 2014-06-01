class CreateReplyTexts < ActiveRecord::Migration
  def change
    create_table :reply_texts do |t|

      t.text :text
      
      t.timestamps
    end
  end
end
