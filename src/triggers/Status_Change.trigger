trigger Status_Change on Application__c (after update) {

    // For each of the Application records being inserted, do the following:
    for(Application__c app : trigger.new){
         if (app.Status__c == 'Offer Accepted' || app.Status__c == 'Rejected' || app.Status__c == 'Recruiter Screen Rejection' || app.Status__c == 'HM Screen Rejection' || app.Status__c == 'Submitted Rejection') {
             List<Email_Reminder__c> emailR = [SELECT Id FROM Email_Reminder__c WHERE Application__c =: app.Id];
             for (Email_Reminder__c email : emailR) {
                 delete emailR;
             }
             
             
         }
           
        
    }
        
     
}