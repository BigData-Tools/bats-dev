global class FlagCandidateController{

    WebService static boolean isFlagged(string candidateID){
        
        List<Flagged_Junction__c> result = [select Id from Flagged_Junction__c where Candidate__c =:candidateID and Commentor__r.User__c =: UserInfo.getUserId()];
        if(result.size() == 0){
            return false;
        }else{               
            return true;    
        }           
                           
     }

    WebService static boolean Flag(string candidateID){
        
        LIST<Commentor__c> commentors = [select Id from Commentor__c where User__r.Id =: UserInfo.getUserId()];
        if(commentors.size() == 0){
            return false;
        }
        string commentorID = commentors.get(0).Id;
        Flagged_Junction__c newFlag = new Flagged_Junction__c(Candidate__c = candidateID, Commentor__c = commentorID);
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.useDefaultRule = true;
        newFlag.setOptions(dmlOpts);
                    
        // Insert the new flag
        INSERT newFlag;
        return true;
                                 
     }
        
     WebService static void Unflag(string candidateID){
        LIST<Commentor__c> commentors = [select Id from Commentor__c where User__r.Id =: UserInfo.getUserId()];
        if(commentors.size() == 0){
            return;
        }  
        string commentorID = commentors.get(0).Id;            
        Flagged_Junction__c oldFlag = [select Id from Flagged_Junction__c where Candidate__c =:candidateID and Commentor__c = :commentorID ].get(0);
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.useDefaultRule = true;
        oldFlag.setOptions(dmlOpts);
                    
        // Delete the old flag
        Delete oldFlag;
     }
     
    /*------------ Tests only below this line ------------*/
    static testMethod void testFlagCandidateController(){
        boolean tmp;
        
        Candidate__c c = new Candidate__c();
        c.email__c = 'user@user.com';
        c.first_name__c = 'first';
        c.last_name__c = 'last';
        insert c;
         
        tmp = FlagCandidateController.isFlagged(c.Id);
        tmp = FlagCandidateController.Flag(c.Id);
        FlagCandidateController.Unflag(c.Id);
          
        User user = [SELECT Id, FirstName, LastName, Email FROM User WHERE Id =: UserInfo.getUserId()].get(0);
        
        Commentor__c m = new Commentor__c(User__c = user.Id, First_Name__c = user.FirstName, Last_Name__c = user.LastName, Email__c = user.Email);
        insert m;        
        
        tmp = FlagCandidateController.isFlagged(c.Id);
        tmp = FlagCandidateController.Flag(c.Id);
        FlagCandidateController.Unflag(c.Id);
    }
}