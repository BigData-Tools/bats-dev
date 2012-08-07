global class FlagCandidateController{

    //public Candidate__c candidate;
    //public Commentor__c commentor;   

    WebService static void Flag(string candidateID, string commentorID){
        //Candidate__c candidate = [select Id from Candidate__c where Id=:candidateID].get(0);
        //Commentor__c commentor = [select Id from Commentor__c where Id=:commentorID].get(0);
        
        
        Flagged_Junction__c newFlag = new Flagged_Junction__c(Candidate__c=candidateID, Commentor__c=commentorID);
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.useDefaultRule = true;
        newFlag.setOptions(dmlOpts);
                    
        // Insert the new position
        INSERT newFlag;
        return;                          
     }
        
     public PageReference Unflag() {
         return null;
     }
}