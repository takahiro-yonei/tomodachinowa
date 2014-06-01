global with sharing class UnitTest_Helper {



  global static User setupUser(String userName){

    Profile p = [Select Id, Name From Profile Where Name = 'Chatter Free User'];

    User testUser = new User(
      Alias = 'newUser',
      Email='takahiro-yonei@taodrive.com',
      ProfileId = p.Id,
      UserName = userName,
      LastName = 'test',
      TimeZoneSidKey = 'America/Los_Angeles',
      LocaleSidKey = 'en_US',
      EmailEncodingKey = 'UTF-8',
      LanguageLocaleKey = 'en_US'
    );
    insert testUser;

    testUser = [Select Id,Alias,Email,ProfileId,UserName,LastName,
        TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,LanguageLocaleKey
      From User Where Id = :testUser.Id];
    return testUser;

  }


  global static SystemConfig__c setupSystemConfig(User testUser){
    List<SystemConfig__c> sysConfigs = [Select Name,ProxyUserId__c From SystemConfig__c];
    SystemConfig__c sys;
    if(sysConfigs.isEmpty()){
      sys = new SystemConfig__c(ProxyUserId__c = testUser.Id);
      insert sys;
    } else {
      sys = sysConfigs[0];
    }

    return sys;
  }


}