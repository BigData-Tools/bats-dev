trigger Copy_Tags on Application__c (before insert) {
    
    for(Application__c app : trigger.new){
        // Let's get the position object that we want to copy from
        Position__c position = [SELECT Id, Coordinator__c, Hiring_Manager__c, Recruiter__c FROM Position__c WHERE Id =: app.Position__c].get(0);   
        
        // Copy the fields over
        if (app.Coordinator__c == null) {
            app.Coordinator__c = position.Coordinator__c;
        }
        if (app.Hiring_Manager__c == null) {
            app.Hiring_Manager__c = position.Hiring_Manager__c;
        }
        
        if (app.Recruiter__c == null) {
            app.Recruiter__c = position.Recruiter__c; 
        }
        // Let's get the candidate object we want to copy from
        Candidate__c candidate = [SELECT Id, Email__c FROM Candidate__c WHERE Id =: app.Candidate__c].get(0);
        
        app.Candidate_Email_Address__c = candidate.Email__c;    
    }
}