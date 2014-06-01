class FeedItem < ActiveRecord::Base


  #-----------------------------------------------
  # 投稿内容を記録する
  def self.save_feed_item(params)
    new_feed_item = FeedItem.new do |item|
      item.user_id = params[:user_id]
      item.org_id = params[:organization_id]
      item.feed_id = params[:feed_id]
      item.feed_body = params[:feed_body]
    end

    new_feed_item.save!
    return new_feed_item
  end


  #-----------------------------------------------
  # 自身以外のUserを選んで、Feed内容を転送する
  def forward_to_others

    new_fwds = []

    fwd_to_users = User.select_forward_to(self.user_id)
    fwd_to_users.each do |user|
      puts '------- user: ' + user.user_id

      client = user.create_client_to_force

      feed_body = {
        "body" => {
          "messageSegments" => [
            {"type" => "text", "text" => self.feed_body}
          ]
        }
      }

      res = client.post "/services/data/v29.0/chatter/feeds/news/me/feed-items", feed_body.to_json

      new_fwd = FeedItemForwading.save_forward_result(self.id, user, res)
      new_fwds.push(new_fwd)
    end
    
    return new_fwds
  end


  #-----------------------------------------------
  # サーバ側で適当に応答する
  def reply_automatically

    from_user = User.where(user_id: self.user_id).first
    return nil if from_user.blank?

    client = from_user.create_client_to_force
    
    comment = ReplyText.select_auto

    feed_body = {
      "body" => {
        "messageSegments" => [
          {"type" => "text", "text" => comment + "\n#サポーター"}
        ]
      }
    }

    res = client.post "/services/data/v29.0/chatter/feed-items/#{self.feed_id}/comments", feed_body.to_json
  end

end
