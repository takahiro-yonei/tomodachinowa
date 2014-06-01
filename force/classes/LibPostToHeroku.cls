global with sharing class LibPostToHeroku {

  global final static String HASH_TAG_SHARE = '#癒されたい';
  global final static String HASH_TAG_FROM_SUPPORTER = '#サポーター';
  global final static String HASH_TAG_FORWARDED = '#あなたの一言が誰かを救うかも';

  global LibPostToHeroku(){}


  /**
   * Heroku経由で他の環境に転送するFeedItemを抽出する
   *  - ハッシュタグ = #癒されたい であること
   */
  global static Map<Id, String> filterFeedItemParamsToPost(List<FeedItem> orgFeedItems){
    Id proxyUserId = LibSystemConfig.getProxyUserId();

    Map<Id, String> res = new Map<Id, String>();
    for(FeedItem item : orgFeedItems){
      if(String.isNotBlank(item.Body) && item.Body.contains(HASH_TAG_SHARE)){
        res.put(item.Id, item.Body);
      }
    }

    return res;
  }

  /**
   * Heroku経由でFeed元にコメントを転送するFeedCommentを抽出する
   *  - Feedのハッシュタグ = #あなたの一言が誰かを救うかも であること
   *  - コメントにハッシュタグ #サポーター がついてないこと(=サーバからの自動応答、他ユーザのコメントでないこと)
   */
  global static Map<Id, String> filterFeedCommentParamsToPost(List<FeedComment> orgFeedComments){
    Id proxyUserId = LibSystemConfig.getProxyUserId();

    // 1つのFeedItemIdに複数のFeedCommentがつくことは...通常運用ではないはず
    Map<Id, String> feedItemIdToCommentBodyMap = new Map<Id, String>();
    for(FeedComment comment : orgFeedComments){
      // サーバからの自動応答、他のユーザからのコメント転送を除く
      if(String.isNotBlank(comment.CommentBody) && !comment.CommentBody.contains(HASH_TAG_FROM_SUPPORTER)){
        feedItemIdToCommentBodyMap.put(comment.FeedItemId, comment.CommentBody);
      }
    }

    Map<Id, String> res = new Map<Id, String>();
    for(FeedItem feed : [Select Body,CreatedById From FeedItem Where Id IN :feedItemIdToCommentBodyMap.keySet()]){
      if(String.isNotBlank(feed.Body) && feed.Body.contains(HASH_TAG_FORWARDED)){
        res.put(feed.Id, feedItemIdToCommentBodyMap.get(feed.Id));
      }
    }

    return res;
  }



  /**
   * FeedCommentを元のFeedに転送する
   *  @param Map<Id, String> feedItemMap key: FeedItem.Id, value: FeedItem.Body
   */
  @future(callout=true)
  global static void doPostToHelpMe(Map<Id, String> feedItemMap){
    if(feedItemMap.isEmpty()){
      return;
    }

    try{

      Id proxyUserId = LibSystemConfig.getProxyUserId();

      for(Id feedId : feedItemMap.keySet()){
        String feedBody = feedItemMap.get(feedId);
        feedBody = feedBody.replaceAll(HASH_TAG_SHARE, HASH_TAG_FORWARDED);

        Map<String, String> paramMap = new Map<String, String>{
          'user_id' => proxyUserId,
          'organization_id' => UserInfo.getOrganizationId(),
          'feed_id' => feedId,
          'feed_body' => feedBody
        };

        HttpResponse res = postToHeroku('helpme', paramMap);
      }

    }catch(Exception ex){
      System.debug('Line:[' + ex.getLineNumber() + '] ' + ex.getMessage() + '/' + ex.getStackTraceString());
      throw ex;
    }
  }

  /**
   * FeedCommentを元のFeedに転送する
   *  @param Map<Id, String> feedCommentMap key: FeedComment.FeedItemId, value: FeedComment.Body
   */
  @future(callout=true)
  global static void doPostToHelpYou(Map<Id, String> feedCommentMap){
    if(feedCommentMap.isEmpty()){
      return;
    }

    try{

      Id proxyUserId = LibSystemConfig.getProxyUserId();

      for(Id feedId : feedCommentMap.keySet()){
        Map<String, String> paramMap = new Map<String, String>{
          'to_feed_id' => feedId,
          'comment_body' => feedCommentMap.get(feedId),
          'comment_user_id' => proxyUserId
        };

        HttpResponse res = postToHeroku('helpyou', paramMap);
      }

    }catch(Exception ex){
      System.debug('Line:[' + ex.getLineNumber() + '] ' + ex.getMessage() + '/' + ex.getStackTraceString());
      throw ex;
    }
  }

  

  /**
   * Salesforce -> Heroku
   */
  private static HttpResponse postToHeroku(String toPath, Map<String, String> paramMap){
    try{
      HttpRequest req = new HttpRequest();

      Id proxyUserId = LibSystemConfig.getProxyUserId();

      req.setEndpoint('https://tomodachinowa.herokuapp.com/' + toPath);
      req.setMethod('POST');
      req.setHeader('X-Sfdc-UserId', proxyUserId);
      req.setHeader('X-Sfdc-OrganizationId', UserInfo.getOrganizationId());

      req.setTimeout(30000);

      List<String> params = new List<String>();
      for(String key : paramMap.keySet()){
        params.add(key + '=' + paramMap.get(key));
      }
      String sendBody = String.join(params, '&');

      System.debug('----- sendBody: ' + sendBody);

      req.setBody(sendBody);

      Http http = new Http();
      HttpResponse res = http.send(req);

      return res;
    }catch(Exception ex){
      System.debug('Line:[' + ex.getLineNumber() + '] ' + ex.getMessage() + '/' + ex.getStackTraceString());
      throw ex;
    }
  }
}