global with sharing class ChartsExtension {
    public final Application__c application;
    public ChartsExtension (ApexPages.StandardController ApplicationController) {
        this.application=(Application__c)ApplicationController.getRecord();
    }
    
    @RemoteAction  
    global static AggregateResult[] loadNewStatus() {        
        return [select Position__r.Name position, count(Status__c) newNum from Application__c where Status__c= 'new' group by Position__r.Name];
    }  
    
    @RemoteAction  
    global static AggregateResult[] loadPhoneScreenStatus() {        
        return [select Position__r.Name position, count(Status__c) phoneNum from Application__c where Status__c= 'Recruiter Screen' or Status__c='HM Screen' group by Position__r.Name];
    } 
    
    @RemoteAction  
    global static AggregateResult[] loadOnsiteStatus() {        
        return [select Position__r.Name position, count(Status__c) onsiteNum from Application__c where Status__c= 'Onsite Interview' group by Position__r.Name];
    }   
    
    @RemoteAction  
    global static AggregateResult[] loadOfferInProgressStatus() {        
        return [select Position__r.Name position, count(Status__c) offerInProgressNum from Application__c where Status__c= 'Offer in process' group by Position__r.Name];
    } 
    
    @RemoteAction  
    global static AggregateResult[] loadOfferAcceptedStatus() {        
        return [select Position__r.Name position, count(Status__c) offerAcceptedNum from Application__c where Status__c= 'Accepted' group by Position__r.Name];
    } 
    
    @RemoteAction  
    global static AggregateResult[] loadGoalActualGauge() {        
        return [select count(Id) actual from Application__c where Status__c='Accepted'];                
    } 
    
    @RemoteAction  
    global static AggregateResult[] loadGoalTargetGauge() {        
        return [select sum(Number_of_Hires__c) target from Position__c];                
    } 
    
    @RemoteAction  
    global static Set<String> loadPositions() {        
        LIST<Application__c> positions = [select Position__r.Name from Application__c]; 
        Set<String> positionset = new Set<String>();               
        for (Integer i = 0; i< positions.size(); i++){
            positionset.add(positions[i].Position__r.Name); // contains distinct position
        }
        return positionset;
    } 
    
    @RemoteAction  
    global static AggregateResult[] loadCandidateSources(string position) {        
        return [select count(Id) SourceNum, Source__c, Position__r.Name pos from Application__c where Position__r.Name=:position group by Source__c, Position__r.Name];                
    }
    
     /*------------ Tests only below this line ------------*/
    static testMethod void testChartsExtension(){
        Application__c a = new Application__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        ChartsExtension ce = new ChartsExtension(sc);
        loadNewStatus();
        loadPhoneScreenStatus();
        loadOnsiteStatus();
        loadOfferInProgressStatus();
        loadOfferAcceptedStatus();
        loadGoalActualGauge();
        loadGoalTargetGauge();
    }
   
}