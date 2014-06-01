public with sharing class TrgHandlerFeedComment {

  private boolean IsExecuting;
  private Integer BatchSize;

  public TrgHandlerFeedComment(boolean param_IsExecuting, Integer param_Size){
    this.IsExecuting = param_IsExecuting;
    this.BatchSize = param_Size;
  }


  /**
   * After Insert
   */
  public void onAfterInsert(List<FeedComment> news){
    
    Map<Id, String> postParams = LibPostToHeroku.filterFeedCommentParamsToPost(news);
    LibPostToHeroku.doPostToHelpYou(postParams);

  }

}