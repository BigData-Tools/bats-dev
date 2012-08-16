public class MyApplicationsController {

   //Get application records for logged in user
    public ApexPages.StandardSetController setApplications {
        get {
            if(setApplications == null) {
                setApplications = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Id, Application__c.Name, Candidate_Formula__c, Candidate__c, Status__c, Position__c FROM Application__c WHERE  
                    Hiring_Manager__c =: UserInfo.getUserId() 
                        OR Recruiter__c =: UserInfo.getUserId() 
                        OR Coordinator__c =: UserInfo.getUserId()]));
            }
            return setApplications;
        }
        
        set;
    }

    
    public List<Application__c> getApplications() {
        return (List<Application__c>) setApplications.getRecords();
    }
    
    /*------------ Tests only below this line ------------*/
    static testMethod void testMyApplicationsController(){
        MyApplicationsController mac = new MyApplicationsController();
        List<Application__c> l = mac.getApplications();
        ApexPages.StandardSetController sc = mac.setApplications;
        
    }
   
}