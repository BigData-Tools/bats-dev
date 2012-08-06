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
}