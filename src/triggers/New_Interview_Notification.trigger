trigger New_Interview_Notification on Interview__c (after insert) {
    for (Interview__c interview : Trigger.new) {
    
        // Format the date into vCal accepted format
        String convertedDate = interview.Interview_Datetime__c.format('yyyyMMdd', 'PST');
        String convertedTime = interview.Interview_Datetime__c.format('HHmm', 'PST');
        String convertedDateTime = convertedDate + 'T' + convertedTime + '00';
        
        // Format current datetime into vCal accepted format
        Datetime now = System.now();
        String convertedNowDate = now.format('yyyyMMdd', 'PST');
        String convertedNowTime = now.format('HHmm', 'PST');
        String convertedNowDateTime = convertedNowDate + 'T' + convertedNowTime + '00';
    
        // Start a new email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        // Start a new attachment in email
        Messaging.EmailFileAttachment[] attachments = new Messaging.EmailFileAttachment[0];
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('Interview.ics');
        // Populate vCal
        String vCal = 'BEGIN:VCALENDAR' + '\n' + 'PRODID:-//Box Recruiting//iCalendar Export//EN' + '\n' +
'VERSION:2.0' + '\n' + 'METHOD:REQUEST'+ '\n'+ 'BEGIN:VEVENT'+ '\n' +
'DTSTART;TZID=US/Pacific:' + convertedDateTime + '\n' + 'DURATION:PT1H0M0S' + '\n' + 'DTSTAMP:' + convertedNowDateTime + '\n' +
'UID:'+ System.currentTimeMillis() + '-' + interview.id + '@box.com' + '\n' +
'CREATED:' + convertedNowDateTime + '\n' + 'DESCRIPTION:' + interview.Interview_Type__c + ' Interview' + '\n' +
'SEQUENCE:0' + '\n' + 'STATUS:CONFIRMED' + '\n' + 'SUMMARY:Interview' + '\n' + 'TRANSP:OPAQUE' + '\n' + 
'END:VEVENT'+ '\n' + 'END:VCALENDAR';
 
        // Put vCal into attachment and put attachment in email
        efa.setBody(blob.valueOf(vCal));
        attachments.add(efa);
        efa.setContentType('text/calendar');
        mail.setFileAttachments(attachments);
        
        //get the candidate's first & last name
        Candidate__c candidate = [SELECT First_Name__c, Last_Name__c, Email__c from Candidate__c where Id in (SELECT Candidate__c from Application__c where Id = :interview.Application__c)].get(0);
        
        // Setup email parameters before sending
        mail.setToAddresses(new String[] {candidate.Email__c});
        mail.setSenderDisplayName('Box Recruiting System');
        mail.setReplyTo('test2@example.com');
        mail.setSubject('Your Box Interview Schedule');
        mail.setPlainTextBody(
            'Hello ' + candidate.First_Name__c + ' ' + candidate.Last_Name__c + ',\n' +
            '\n' +
            'Your interview schedule' +
            '\n\n'
        );
        
        // Send email
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    
        
    }
}