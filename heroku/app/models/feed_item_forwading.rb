class FeedItemForwading < ActiveRecord::Base


  #-----------------------------------------------
  # コメントを受け取って、元のUserに転送する
  def receive_comment(reply_text)
    
    # コメントを返すために、元々のFeedとUser情報を取得する
    original_feed = FeedItem.find(self.feed_item_id)
    original_user = User.where(user_id: original_feed.user_id, is_valid: true).first

    # コメントしたUser情報を取得する
    fwd_user = User.where(user_id: self.to_user_id, is_valid: true).first

    raise 'not found user..' if (original_user.blank? || fwd_user.blank?)

    client = original_user.create_client_to_force
    
    comment = reply_text
    feed_body = {
      "body" => {
        "messageSegments" => [
          {"type" => "text", "text" => comment + "\n#サポーター"}
        ]
      }
    }

    res = client.post "/services/data/v30.0/chatter/feed-items/#{original_feed.feed_id}/comments", feed_body.to_json

    # コメント済であることを登録しておく
    self.is_replied = true
    self.reply_body = reply_text
    self.save!

    return self
  end


  #-----------------------------------------------
  # 転送結果を登録する
  def self.save_forward_result(feed_item_id, to_user, res)
    
    new_fwd = FeedItemForwading.new do |f|
      f.feed_item_id = feed_item_id
      f.to_org_id = to_user.org_id
      f.to_user_id = to_user.user_id
      f.fowarding_feed_id = res.body.id
      f.reply_body = res.body.body.text
    end

    new_fwd.save!

    return new_fwd
  end
end
