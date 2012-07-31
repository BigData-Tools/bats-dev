global with sharing class CandidateChartsExtension {
    public final Candidate__c candidate;
    public CandidateChartsExtension(ApexPages.StandardController CandidateController) {
        this.candidate =(Candidate__c)CandidateController.getRecord();
    }
    
    @RemoteAction  
    global static AggregateResult[] loadState() {
        return [select count(Id) StateNum, State__c from Candidate__c group by State__c limit 10];
    }  
    
    @RemoteAction  
    global static AggregateResult[] loadEducation() {
        return [select count(Id) EducationNum, Education__c from Candidate__c group by Education__c];
    }  

    
    /*------------ Tests only below this line ------------*/
     static testMethod void testCandidateChartsExtension(){
        ApexPages.standardController CandidateController;
        Candidate__c c1 = new Candidate__c();
        ApexPages.StandardController sc = new ApexPages.standardController(c1);
        CandidateChartsExtension cce = new CandidateChartsExtension(sc);
        Candidate__c c2 = cce.candidate;
        CandidateChartsExtension.loadState();
        CandidateChartsExtension.loadEducation();
     }
}