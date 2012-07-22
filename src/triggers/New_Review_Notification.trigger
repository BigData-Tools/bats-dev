trigger New_Review_Notification on Review__c (after insert) {
    for(Review__c review : Trigger.new){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        //get the application (prerequisite for candidate info)
        Application__c application = [SELECT Candidate__c FROM Application__c WHERE Id = :review.Application__c].get(0);
        
        //get the candidate's first & last name
        Candidate__c candidate = [SELECT First_Name__c, Last_Name__c FROM Candidate__c WHERE Id = :application.Candidate__c];
        
        //get the commentor's email & first name
        Commentor__c commentor = [SELECT Email__c, First_Name__c FROM Commentor__c WHERE Id = :review.Commentor__c];
    
        String[] toAddresses = new String[] {commentor.Email__c}; 
        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('Box Recruiting System');
        mail.setReplyTo('test2@example.com');
        mail.setSubject('Box Interview: Please leave comments about ' + candidate.First_Name__c + ' ' + candidate.Last_Name__c);

        String urlSafefullName = EncodingUtil.urlEncode( + candidate.First_Name__c + ' ' + candidate.Last_Name__c, 'UTF-8');

        mail.setPlainTextBody(
            commentor.First_Name__c + ',\n' +
            '\n' +
            'Our system indicates that you have interviewed (or will soon interview) ' + candidate.First_Name__c + ' ' + candidate.Last_Name__c + '.\n' +
            '\n' +
            'https://commentboxats.appspot.com/' + review.Id + '/' + urlSafefullName + '\n' +
            '\n' +
            'Please do the following:\n' +
            '1. Visit the link above.\n' +
            '2. Log in with your @box.com email address.\n' +
            '3. Leave comments and a rating.\n' +
            '\n' +
            'ReviewID: ' + review.Name + '\n'
        );
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    
    }        
}