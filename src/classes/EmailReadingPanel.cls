public class EmailReadingPanel{

    public EmailCommunication__c emailCommunication{
        public get;
        public set;
    }
    
    public EmailReadingPanel(){
        String emailId = ApexPages.currentPage().getParameters().get('emailId');
        emailCommunication = new EmailCommunication__c();
        if(emailId == null || emailId.length() < 1){
            ApexPages.Message failureMessage = new ApexPages.Message(ApexPages.Severity.ERROR , 'Invalid Email ID');
            ApexPages.addMessage(failureMessage);
        }else{
            emailCommunication = [select Message__c, CandidateSender__c, Subject__c from EmailCommunication__c where Id = :emailId];
        }
    }
    
    public EmailReadingPanel(ApexPages.StandardController stdController){
        This();
    }
    
     /*------------ Tests only below this line ------------*/
    static testMethod void testEmailReadingPanel(){
        EmailReadingPanel erp = new EmailReadingPanel();
        EmailCommunication__c ec = erp.emailCommunication;

        //set current page to have an email id
        
        Candidate__c c = new Candidate__c();      
        c.First_Name__c = 'user';
        c.Last_Name__c = 'user';
        c.Email__c = 'user@user.com';
        insert c;
        
        EmailCommunication__c ec2 = new EmailCommunication__c();
        ec2.Candidate__c = c.Id;
        insert ec2;
        
        PageReference pageRef = Page.ApplyUpload;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('emailId', ec2.Id);
        EmailReadingPanel erp2 = new EmailReadingPanel();
        
        Application__c a = new Application__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        EmailReadingPanel erp3 = new EmailReadingPanel(sc);
    }
}