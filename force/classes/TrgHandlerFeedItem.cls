public with sharing class TrgHandlerFeedItem {

  private boolean IsExecuting;
  private Integer BatchSize;

  public TrgHandlerFeedItem(boolean param_IsExecuting, Integer param_Size){
    this.IsExecuting = param_IsExecuting;
    this.BatchSize = param_Size;
  }


  /**
   * After Insert
   */
  public void onAfterInsert(List<FeedItem> news){

    Map<Id, String> postParams = LibPostToHeroku.filterFeedItemParamsToPost(news);
    LibPostToHeroku.doPostToHelpMe(postParams);

  }



}