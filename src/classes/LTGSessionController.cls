public with sharing class LTGSessionController {
@AuraEnabled
    public static List<Session__c> getSessions() {
        List<session__C> sessions = 
                [SELECT Id, Name, Description__c,Level__c, Session_Date__c  FROM session__C];
     
        return sessions;
    }   
     
}