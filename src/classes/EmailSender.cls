public class EmailSender{

    
    public List<Candidate__c> candidateList{
        public get;
        public set;
    }
    
    public EmailCommunication__c emailCommunication{
        public get;
        public set;
    }
    
    private Id candidateId;
    
    /**
    * @description the class constructor which will initialize the email communication object and get the list of
    * possible cadidate contacts
    */
    public EmailSender(){
       emailCommunication = new emailCommunication__c();
       candidateList = [select First_Name__c, Last_Name__c, Email__c from Candidate__c];
    }
    
    public EmailSender(ApexPages.StandardController stdController) {
        emailCommunication = new emailCommunication__c();
        candidateId = stdController.getId();
        try {
           emailCommunication.Candidate__c = candidateId;
           emailCommunication.CandidateSender__c = false;
        } catch (Nullpointerexception e) {
           return;
        }
    }

    
    /**
    * @description the getter method for candidate list
    * @return List<SelectOption> which will be select HTML list in the email communication page
    */
    /*public List<SelectOption> getCandidates() {
        List<SelectOption> options = new List<SelectOption>();
        for(Integer i = 0; i < candidateList.size(); i++){ 
            options.add(new SelectOption(candidateList.get(i).Email__c, candidateList.get(i).First_Name__c + ' ' + candidateList.get(i).Last_Name__c));
        }
        return options;
    }*/

    /**
    * @description this method is the action for sending the email to the candidates
    * @return PageReference
    */
    public PageReference sendEmail(){
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            Candidate__c selectedCandidate = [select id, First_Name__c, Last_Name__c, Email__c from Candidate__c where id = :candidateId limit 1];  
            String[] toAddresses = new String[] {selectedCandidate.Email__c}; 
            mail.setToAddresses(toAddresses);
            EmailServicesAddress emailServicesAddress = [select LocalPart, EmailDomainName from EmailServicesAddress limit 1];
            mail.setReplyTo(emailServicesAddress.LocalPart + '@' + emailServicesAddress.EmailDomainName);       
            mail.setSenderDisplayName(UserInfo.getOrganizationName());   
            mail.setSubject(emailCommunication.Subject__c);  
            mail.setBccSender(false);
            mail.setUseSignature(false);   
            //mail.setPlainTextBody(emailCommunication.Message__c);
            mail.setHtmlBody(emailCommunication.Message__c);     
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            emailCommunication.CandidateSender__c = false;
            emailCommunication.Candidate__c = selectedCandidate.id;
            insert emailCommunication;
            ApexPages.Message successMessage = new ApexPages.Message(ApexPages.Severity.CONFIRM , 'Your email was sent to: ' + selectedCandidate.First_Name__c + ' ' + selectedCandidate.Last_Name__c);
            ApexPages.addMessage(successMessage);
        }catch(Exception e){
            ApexPages.Message failedMessage = new ApexPages.Message(ApexPages.Severity.ERROR , e.getMessage());
            ApexPages.addMessage(failedMessage);
        }
        return null;  
    }
    
     /*------------ Tests only below this line ------------*/
    static testMethod void testEmailSender(){
	    //test default constructor
	    EmailSender es = new EmailSender();
	    
	    //test constructor which takes standard controller
	    Application__c a = new Application__c();    
	    
	    
	    Candidate__c c = new Candidate__c();      
	    c.First_Name__c = 'user';
	    c.Last_Name__c = 'user';
	    c.Email__c = 'user@user.com';
	    insert c;
	    
	    a.Candidate__c = c.Id;
	    
	    ApexPages.StandardController sc = new ApexPages.standardController(a);      
	    es = new EmailSender(sc);
	    
	    es.sendEmail();
    }
    
}