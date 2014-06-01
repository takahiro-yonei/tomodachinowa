@isTest
private class UnitTest_LibPostToHeroku {
  


  @isTest static void Test_doPostToHelpMe(){
    Test.setMock(HttpCalloutMock.class, new UnitTest_MockHttpResGenerator());

    User testUser = UnitTest_Helper.setupUser('dcmax-test01xxxx@taodrive.com');
    SystemConfig__c sys = UnitTest_Helper.setupSystemConfig(testUser);

    FeedItem newFeed = new FeedItem(
      Body = 'Test',
      ParentId = testUser.Id
    );
    insert newFeed;

    Map<Id, String> params = new Map<Id, String>{
      newFeed.Id => newFeed.Body
    };


    Test.startTest();

    LibPostToHeroku.doPostToHelpMe(params);

    Test.stopTest();

  }

  
  @isTest static void Test_doPostToHelpYou(){
    Test.setMock(HttpCalloutMock.class, new UnitTest_MockHttpResGenerator());

    User testUser = UnitTest_Helper.setupUser('dcmax-test01xxxx@taodrive.com');
    SystemConfig__c sys = UnitTest_Helper.setupSystemConfig(testUser);

    FeedItem newFeed = new FeedItem(
      Body = 'Test',
      ParentId = testUser.Id
    );
    insert newFeed;

    Map<Id, String> params = new Map<Id, String>{
      newFeed.Id => newFeed.Body
    };


    Test.startTest();

    LibPostToHeroku.doPostToHelpYou(params);

    Test.stopTest();

  }
  
}