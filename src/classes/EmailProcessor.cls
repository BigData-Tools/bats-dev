global class EmailProcessor implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        EmailCommunication__c emailCommunication = new EmailCommunication__c();
        emailCommunication.CandidateSender__c = true;
        emailCommunication.Message__c = email.plainTextBody;
        emailCommunication.Subject__c = email.Subject;
        emailCommunication.Candidate__c = [select id from Candidate__c where email__c = :email.fromAddress limit 1].id;
        insert emailCommunication;
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        return result;
    }
      
    /*------------ Tests only below this line ------------*/
    static testMethod void testEmailProcessor(){
        //create email
        Messaging.InboundEmail email = new Messaging.InboundEmail();        
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        Candidate__c c = new Candidate__c();
        c.email__c = 'user@user.com';
        c.first_name__c = 'first';
        c.last_name__c = 'last';
        insert c;
        email.fromAddress = c.email__c;

        //run test
        EmailProcessor ep = new EmailProcessor();
        ep.handleInboundEmail(email, envelope);
    }
  }