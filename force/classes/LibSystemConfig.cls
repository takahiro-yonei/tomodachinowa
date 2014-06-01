global with sharing class LibSystemConfig {

  private static SystemConfig__c sys;

  global static Id getProxyUserId(){
    try{
      if(sys == null){
        sys = [Select ProxyUserId__c,IsForwardToHeroku__c From SystemConfig__c limit 1];
      }
      
      return Id.valueOf(sys.ProxyUserId__c);
    }catch(Exception ex){
      System.debug('Line:[' + ex.getLineNumber() + '] ' + ex.getMessage() + '/' + ex.getStackTraceString());
      return null;
    }
  }

  global static Boolean isTriggerDisabled(){
    try{
      if(sys == null){
        sys = [Select ProxyUserId__c,IsForwardToHeroku__c From SystemConfig__c limit 1];
      }
      
      return sys.IsForwardToHeroku__c;
    }catch(Exception ex){
      System.debug('Line:[' + ex.getLineNumber() + '] ' + ex.getMessage() + '/' + ex.getStackTraceString());
      return false;
    }
  }


  global class LibSystemConfigException extends Exception {}
}