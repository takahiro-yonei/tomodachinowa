trigger SystemConfigTrigger on SystemConfig__c (before insert) {


  if(Trigger.isBefore && Trigger.isInsert){
    List<SystemConfig__c> sys = [Select Name From SystemConfig__c];
    if(!sys.isEmpty()){
      Trigger.new[0].addError('既に作成されています。');
    }
  }
}