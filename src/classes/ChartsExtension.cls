global with sharing class ChartsExtension {
    public final Application__c application;
    public ChartsExtension (ApexPages.StandardController ApplicationController) {
        this.application=(Application__c)ApplicationController.getRecord();
    }
    
    @RemoteAction  
    global static AggregateResult[] loadNewStatus() {        
        return [select Position__r.Name position, count(Status__c) newNum from Application__c where Status__c= 'new'  and (Recruiter__c = :UserInfo.getUserId() or Hiring_Manager__c = :UserInfo.getUserId() or Coordinator__c = :UserInfo.getUserId()) group by Position__r.Name];
    }  
    
    @RemoteAction  
    global static AggregateResult[] loadPhoneScreenStatus() {        
        return [select Position__r.Name position, count(Status__c) phoneNum from Application__c where (Status__c= 'Recruiter Screen' or Status__c='HM Screen') and (Recruiter__c = :UserInfo.getUserId() or Hiring_Manager__c = :UserInfo.getUserId() or Coordinator__c = :UserInfo.getUserId()) group by Position__r.Name];
    } 
    
    @RemoteAction  
    global static AggregateResult[] loadOnsiteStatus() {        
        return [select Position__r.Name position, count(Status__c) onsiteNum from Application__c where Status__c= 'Onsite Interview' and (Recruiter__c = :UserInfo.getUserId() or Hiring_Manager__c = :UserInfo.getUserId() or Coordinator__c = :UserInfo.getUserId()) group by Position__r.Name];
    }   
    
    @RemoteAction  
    global static AggregateResult[] loadOfferInProgressStatus() {        
        return [select Position__r.Name position, count(Status__c) offerInProgressNum from Application__c where Status__c= 'Offer in process' and (Recruiter__c = :UserInfo.getUserId() or Hiring_Manager__c = :UserInfo.getUserId() or Coordinator__c = :UserInfo.getUserId()) group by Position__r.Name];
    } 
    
    @RemoteAction  
    global static AggregateResult[] loadOfferAcceptedStatus() {        
        return [select Position__r.Name position, count(Status__c) offerAcceptedNum from Application__c where Status__c= 'Accepted' and (Recruiter__c = :UserInfo.getUserId() or Hiring_Manager__c = :UserInfo.getUserId() or Coordinator__c = :UserInfo.getUserId()) group by Position__r.Name];
    } 
    
    @RemoteAction  
    global static AggregateResult[] loadGoalActualGauge() {        
        return [select count(Id) actual from Application__c where Status__c='Accepted' and (Recruiter__c = :UserInfo.getUserId() or Hiring_Manager__c = :UserInfo.getUserId() or Coordinator__c = :UserInfo.getUserId())];                
    } 
    
    @RemoteAction  
    global static AggregateResult[] loadGoalTargetGauge() {        
        return [select sum(Number_of_Hires__c) target from Position__c where (Recruiter__c = :UserInfo.getUserId() or Hiring_Manager__c = :UserInfo.getUserId() or Coordinator__c = :UserInfo.getUserId())];                
    } 
    
    @RemoteAction  
    global static Set<String> loadPositions() {        
        LIST<Application__c> positions = [select Position__r.Name from Application__c where Recruiter__c = :UserInfo.getUserId() or Hiring_Manager__c = :UserInfo.getUserId() or Coordinator__c = :UserInfo.getUserId()]; 
        Set<String> positionset = new Set<String>();               
        for (Integer i = 0; i< positions.size(); i++){
            positionset.add(positions[i].Position__r.Name); // contains distinct positions
        }
        return positionset;
    } 
    
    @RemoteAction  
    global static AggregateResult[] loadCandidateSources(string position) {        
        return [select count(Id) SourceNum, Source__c, Position__r.Name pos from Application__c where Position__r.Name=:position group by Source__c, Position__r.Name];                
    }
    
    @RemoteAction  
    global static AggregateResult[] loadTeamQuarterlyGoalActual() {        
        return [select Position__r.Name position, count(Id) actual from Application__c where Status__c='Accepted' and Position__r.Open_Date__c = THIS_QUARTER group by Position__r.Name];                
    } 
    
    @RemoteAction  
    global static AggregateResult[] loadTeamQuarterlyGoalTarget() {        
        return [select Name position, sum(Number_of_Hires__c) target from Position__c where Open_Date__c = THIS_QUARTER group by Name];                
    }
    
    @RemoteAction  
    global static AggregateResult[] loadTeamQuarterlyHireSources() {        
        return [select count(Id) sourceNum, Source__c source from Application__c where Status__c = 'Accepted' and Position__r.Open_Date__c = THIS_QUARTER group by Source__c];
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
        loadPositions();
        loadCandidateSources('sss');
        
    }
   
}