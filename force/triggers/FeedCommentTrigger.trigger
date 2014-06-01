trigger FeedCommentTrigger on FeedComment (after insert) {
  if(!LibSystemConfig.isTriggerDisabled()){
    return;
  }
  
  TrgHandlerFeedComment handler = new TrgHandlerFeedComment(Trigger.isExecuting, Trigger.size);


  if(Trigger.isAfter && Trigger.isInsert){
    //
    handler.onAfterInsert(Trigger.new);
  }

}