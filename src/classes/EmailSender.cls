public class EmailSender{

    
    public List<Candidate__c> candidateList{
        public get;
        public set;
    }
    
    public String candidateEmail{
        public get;
        public set;
    }
    
    public EmailCommunication__c emailCommunication{
        public get;
        public set;
    }
    
    public boolean html{
        get;
        set;
    }
    
    public EmailSender(){
       emailCommunication = new emailCommunication__c();
       candidateList = [select First_Name__c, Last_Name__c, Email__c from Candidate__c];
    }
    
    public List<SelectOption> getCandidates() {
        List<SelectOption> options = new List<SelectOption>();
        for(Integer i = 0; i < candidateList.size(); i++){ 
            options.add(new SelectOption(candidateList.get(i).Email__c, candidateList.get(i).First_Name__c + ' ' + candidateList.get(i).Last_Name__c));
        }
        return options;
    }

    public PageReference sendEmail(){
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            Candidate__c selectedCandidate = [select id, First_Name__c, Last_Name__c, Email__c from Candidate__c where Email__c = :candidateEmail limit 1];  
            String[] toAddresses = new String[] {selectedCandidate.Email__c}; 
            mail.setToAddresses(toAddresses);
            EmailServicesAddress emailServicesAddress = [select LocalPart, EmailDomainName from EmailServicesAddress limit 1];
            mail.setReplyTo(emailServicesAddress.LocalPart + '@' + emailServicesAddress.EmailDomainName);       
            mail.setSenderDisplayName(UserInfo.getOrganizationName());   
            mail.setSubject(emailCommunication.Subject__c);  
            mail.setBccSender(false);
            mail.setUseSignature(false);   
            mail.setPlainTextBody(emailCommunication.Message__c);
            //mail.setHtmlBody('Your case:<b> ' + case.Id +' </b>has been created.<p>'+
                 //'To view your case <a href=https://na1.salesforce.com/'+case.Id+'>click here.</a>');     
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
    EmailSender ttt = new EmailSender();
    ttt.getCandidates();
    ttt.sendEmail();
    
    }
    
}