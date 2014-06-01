@isTest
private class UnitTest_Trg_FeedComment {


  @isTest static void Test_Feed_with_HashTag(){
    User testUser = UnitTest_Helper.setupUser('dcmax-test01xxxx@taodrive.com');
    SystemConfig__c sys = UnitTest_Helper.setupSystemConfig(testUser);


    Test.startTest();

    FeedItem newFeed = new FeedItem(
      Body = 'Test\n' + LibPostToHeroku.HASH_TAG_SHARE,
      ParentId = testUser.Id
    );
    insert newFeed;

    FeedComment newComment = new FeedComment(
      FeedItemId = newFeed.Id,
      CommentBody = 'ABC'
    );
    insert newComment;

    Test.stopTest();

  }
}