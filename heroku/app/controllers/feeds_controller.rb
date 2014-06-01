class FeedsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :validate_user


  #-----------------------------------------------
  # force.comからのFeedを受け取って、
  # 他組織にランダムに転送する
  def forward_feed

    feed_item = FeedItem.save_feed_item(params)

    begin
      feed_item.reply_automatically
    rescue => err
      puts '--ERR reply_automatically:'
      puts err.backtrace
    end
    
    begin
      feed_item.forward_to_others
      @res = {success: true, errorMessage: '', records: [feed_item], total: 1}
      render :json => @res, :status => 200
    rescue => err
      puts '--ERR forward:'
      puts err.backtrace

      @res = {success: false, errorMessage: err.message, records: [], total: 0}
      render :json => @res, :status => 500
    end

  end

  #-----------------------------------------------
  # 他組織からのCommentを受け取って、Feed元に返す
  #  -> 見つからなかったらスルー...
  def reply_to_orginal_feed
    fwd = FeedItemForwading.where(fowarding_feed_id: params[:to_feed_id]).first
    
    begin
      unless fwd.blank?
        fwd.receive_comment(params[:comment_body])
      end
      @res = {success: true, errorMessage: '', records: [fwd], total: 1}
      render :json => @res, :status => 200
    rescue => err
      puts '--ERR forward:'
      puts err.backtrace

      @res = {success: false, errorMessage: err.message, records: [], total: 0}
      render :json => @res, :status => 500
    end
    
  end

end
