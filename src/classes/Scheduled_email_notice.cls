global class Scheduled_email_notice implements Schedulable {
    
     global void execute(SchedulableContext SC){
                  
        Datetime now = System.now();
        Datetime now3 = now.addDays(-3);

        // Let's get out the list of applications that are over the 3 days mark
        List<Application__c> applications = [SELECT Id,Name,Coordinator__r.Email FROM Application__c WHERE (Status__c != 'Rejected' OR Status__c != 'Accepted' OR Status__c != 'Submitted Rejection' OR Status__c != 'Recruiter Screen Rejection' OR Status__c != 'HM Screen Rejection') AND LastModifiedDate <=: now3 AND Id NOT IN (SELECT Application__c FROM Email_Reminder__c WHERE Last_Email_Datetime__c >: now3)];

        //set up email parametres
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSenderDisplayName('Box.com');
        mail.setSenderDisplayName('Box Recruiting System');
        mail.setReplyTo('msit-practicum-box@googlegroups.com');
        mail.setSubject('Notice');

        //using template
        //EmailTemplate et = [SELECT id FROM EmailTemplate WHERE Name = 'reject_template'];
        //mail.setTemplateId(et.id);

        //iterate List for email and upsert 
        String email=null;
        for(Application__c application:applications){

            // Upsert to Email_Reminder__c
            Email_Reminder__c newRecord= new Email_Reminder__c(Application__c=application.Id, ApplicationID__c=application.Name, Last_Email_Datetime__c=now);
            try {
                upsert newRecord ApplicationID__c;
            } catch (DmlException e) {
                System.debug(e.getMessage());
            }

            // set up email specific parametres
            mail.setPlainTextBody(
                'Application: '+application.Name+' '+' has idled in system for 3 days without any updates. '   + '.\n' 
            );
            mail.setToAddresses(new String[] {application.Coordinator__r.Email});  
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});//sent 
        }
    }
}