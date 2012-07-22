global with sharing class ApplicationChartsExtension {
    public final Application__c application;
    public ApplicationChartsExtension(ApexPages.StandardController ApplicationController) {
        this.application=(Application__c)ApplicationController.getRecord();
    }
    
    @RemoteAction  
    global static AggregateResult[] loadApplicationStatus() {
        return [select count(Id) CandidateNum, Status__c, Position__c from Application__c group by Position__c, Status__c];
    }  
    
   
}