trigger FeedItemTrigger on FeedItem (after insert) {
  if(!LibSystemConfig.isTriggerDisabled()){
    return;
  }
  
  TrgHandlerFeedItem handler = new TrgHandlerFeedItem(Trigger.isExecuting, Trigger.size);


  if(Trigger.isAfter && Trigger.isInsert){
    //
    handler.onAfterInsert(Trigger.new);
  }

}