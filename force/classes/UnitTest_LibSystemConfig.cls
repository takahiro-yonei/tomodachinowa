@isTest
private class UnitTest_LibSystemConfig {
  
  //------------------------------------------------------------
  // Test
  //------------------------------------------------------------
  @isTest static void Test_getProxyUserId(){
    User testUser = UnitTest_Helper.setupUser('dcmax-test01xxxx@taodrive.com');
    SystemConfig__c sys = UnitTest_Helper.setupSystemConfig(testUser);


    Test.startTest();
    
    Id rtnId = LibSystemConfig.getProxyUserId();
    System.assertNotEquals(rtnId, null);

    Test.stopTest();
  }
  
}