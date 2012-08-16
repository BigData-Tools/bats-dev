public class EmbeddedEmailController{

     public List<EmailCommunication__c> emailCommunication{
         public get;
         public set;
     }
     
     public boolean test{
         public get;
         public set;
     }
     
     /**
     * @description this is the class contructor for the standard controller. this will allow for visualforce page
     * to show the communication between the HR and a candidate
     * @param StdController it will pass the Candidate Id to the contructor to get the right candidate
     */
     public EmbeddedEmailController(ApexPages.StandardController stdController) {
        Id candidateId = stdController.getId();
        emailCommunication = [SELECT Candidate__c, CandidateSender__c, Message__c, Subject__c FROM EmailCommunication__c WHERE Candidate__c = :candidateId];

    }
    
    /*------------ Tests only below this line ------------*/
    static testMethod void testEmbeddedEmailController(){
        Application__c a = new Application__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        EmbeddedEmailController eec = new EmbeddedEmailController(sc);
    }
}