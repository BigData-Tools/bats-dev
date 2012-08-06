trigger New_Review_Notification on Review__c (after insert) {
    for(Review__c review : Trigger.new){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        //get the application (prerequisite for candidate info)
        //Application__c application = [SELECT Candidate__c FROM Application__c WHERE Id = :review.Application__c].get(0);
        
        //get the candidate's first & last name
        Candidate__c candidate = [SELECT First_Name__c, Last_Name__c, Email__c FROM Candidate__c WHERE Id in (SELECT Candidate__c from Application__c where Id = :review.Application__c)].get(0);
        
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
               
        // Let's see if this review is tied to an interview
        
        if (review.Interview__c != null) {
        
            // Update the interview record with last interview slot
            Interview__c inter = [Select Id, Last_Interview_Datetime__c from Interview__c where Id =: review.Interview__c].get(0); 
            Integer integerValueOfDuration = Integer.valueOf(review.Interview_Duration__c);    
            inter.Last_Interview_Datetime__c = inter.Last_Interview_Datetime__c.addHours(integerValueOfDuration);
            update inter;
            
            
        
            // to send out ICS invite, we check if reviews added == total number of interviewers stated in the interview
            List<Review__c> allReviews = [SELECT Id,Commentor__r.First_Name__c,Commentor__r.Last_Name__c,Commentor__r.Email__c,Interview_Location__c, Interview_Duration__c, Interview_Datetime__c FROM Review__c WHERE Interview__c =: review.Interview__c ORDER BY Id ASC];
            Integer totalReviews = allReviews.size();
            Interview__c interview = [SELECT Id,Total_Number_of_Interviewers__c,Interview_Datetime__c,Interview_Type__c FROM Interview__c WHERE Id =: review.Interview__c].get(0);
            
            // Get interview details for candidate
            String firstDateTime = '';
            Decimal duration = 0;
            Integer i = 1;
            String description = '';
        
            if (totalReviews == interview.Total_Number_Of_Interviewers__c) {
                
                // Now lets loop through the reviews and send the emails
                for (Review__c eachReview : allReviews) {
                
                
                    // Format the date into vCal accepted format
                    String convertedDate = eachReview.Interview_Datetime__c.format('yyyyMMdd', 'PST');
                    String convertedTime = eachReview.Interview_Datetime__c.format('HHmm', 'PST');
                    String convertedDateTime = convertedDate + 'T' + convertedTime + '00';
                    
                    if (i == 1) {
                        firstDateTime = convertedDateTime;
                    }
                    
                    duration += eachReview.Interview_Duration__c;
                    description += i + ') Interview with ' + eachReview.Commentor__r.First_Name__c + ' ' + eachReview.Commentor__r.Last_Name__c + '(' + eachReview.Interview_Duration__c + 'hour(s)) at/on ' + eachReview.Interview_Location__c + ' ';
                    
                    // Format current datetime into vCal accepted format
                    Datetime now = System.now();
                    String convertedNowDate = now.format('yyyyMMdd', 'PST');
                    String convertedNowTime = now.format('HHmm', 'PST');
                    String convertedNowDateTime = convertedNowDate + 'T' + convertedNowTime + '00';
                
                
                    // Start a new email
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    // Start a new attachment in email
                    Messaging.EmailFileAttachment[] attachments = new Messaging.EmailFileAttachment[0];
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setFileName('Interview.ics');
                    // Populate vCal
                    String vCal = 'BEGIN:VCALENDAR' + '\n' + 'PRODID:-//Box Recruiting//iCalendar Export//EN' + '\n' +
                        'VERSION:2.0' + '\n' + 'METHOD:REQUEST'+ '\n'+ 'BEGIN:VEVENT'+ '\n' +
                        'DTSTART;TZID=US/Pacific:' + convertedDateTime + '\n' + 'DURATION:PT' + eachReview.Interview_Duration__c + 'H0M0S' + '\n' + 'DTSTAMP:' + convertedNowDateTime + '\n' +
                        'UID:'+ System.currentTimeMillis() + '-' + interview.id + '@box.com' + '\n' +
                        'CREATED:' + convertedNowDateTime + '\n' + 'DESCRIPTION:' +  + 'Interview' + '\n' + 'LOCATION:' + eachReview.Interview_Location__c + '\n' +
                        'SEQUENCE:0' + '\n' + 'STATUS:CONFIRMED' + '\n' + 'SUMMARY:Interview' + '\n' + 'TRANSP:OPAQUE' + '\n' + 
                        'END:VEVENT'+ '\n' + 'END:VCALENDAR';
             
                    // Put vCal into attachment and put attachment in email
                    efa.setBody(blob.valueOf(vCal));
                    attachments.add(efa);
                    efa.setContentType('text/calendar');
                    email.setFileAttachments(attachments);
                    
                    
                    // Setup email parameters before sending
                    email.setToAddresses(new String[] {eachReview.Commentor__r.Email__c});
                    email.setSenderDisplayName('Box Recruiting System');
                    email.setReplyTo('test2@example.com');
                    email.setSubject('Your Box Interview Schedule with ' + candidate.First_Name__c + ' ' + candidate.Last_Name__c);
                    email.setPlainTextBody(
                        'Hello ' + eachReview.Commentor__r.First_Name__c + ' ' + eachReview.Commentor__r.Last_Name__c + ',\n' +
                        '\n' +
                        'Your interview schedule' +
                        '\n\n'
                    );
            
                    // Send email
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });   
                    i++;
                }
                
                // Finally, lets send the ICS file to the candidate
                // Start a new email
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                // Start a new attachment in email
                Messaging.EmailFileAttachment[] attachments = new Messaging.EmailFileAttachment[0];
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName('Interview.ics');
                // Populate vCal
                String vCal = 'BEGIN:VCALENDAR' + '\n' + 'PRODID:-//Box Recruiting//iCalendar Export//EN' + '\n' +
                    'VERSION:2.0' + '\n' + 'METHOD:REQUEST'+ '\n'+ 'BEGIN:VEVENT'+ '\n' +
                    'DTSTART;TZID=US/Pacific:' + firstDateTime + '\n' + 'DURATION:PT' + duration + 'H0M0S' + '\n' + 'DTSTAMP:' + firstDateTime + '\n' +
                    'UID:'+ System.currentTimeMillis() + '-' + interview.id + '@box.com' + '\n' +
                    'CREATED:' + firstDateTime + '\n' + 'DESCRIPTION:' + description + '\n' +
                    'SEQUENCE:0' + '\n' + 'STATUS:CONFIRMED' + '\n' + 'SUMMARY:Interview' + '\n' + 'TRANSP:OPAQUE' + '\n' + 
                    'END:VEVENT'+ '\n' + 'END:VCALENDAR';
         
                // Put vCal into attachment and put attachment in email
                efa.setBody(blob.valueOf(vCal));
                attachments.add(efa);
                efa.setContentType('text/calendar');
                email.setFileAttachments(attachments);
                
                
                // Setup email parameters before sending
                email.setToAddresses(new String[] {candidate.Email__c});
                email.setSenderDisplayName('Box Recruiting System');
                email.setReplyTo('test2@example.com');
                email.setSubject('Your Box Interview Schedule');
                email.setPlainTextBody(
                    'Hello ' + candidate.First_Name__c + ' ' + candidate.Last_Name__c + ',\n' +
                    '\n' +
                    'Your interview schedule' +
                    '\n\n'
                );
        
                // Send email
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });          
    
            }
                      
        }
                    
    }        
}