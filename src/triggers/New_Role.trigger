trigger New_Role on Role__c (after insert) {
    if(trigger.isInsert){
        List<Application__Share> appShares  = new List<Application__Share>();
        List<Position__Share> posShares = new List<Position__Share>();
    
        // For each of the Role records being inserted, do the following:
        for(Role__c role : trigger.new){
        
            // Grab all Applications that has the same department as the one that is being inserted
            List<Application__c> apps = [SELECT Id FROM Application__c a WHERE Position__r.Department__c = :role.Department__c];
    
            for(Application__c app : apps) {
            
                Application__Share appShare = new Application__Share();
                appShare.ParentId = app.Id;
                appShare.UserOrGroupId = role.User__c;
                appShare.AccessLevel = 'edit';
                appShare.RowCause = Schema.Application__Share.RowCause.Authenticated_Site_Sharing_Access__c;
                appShares.add(appShare);
                
            
            }

            // Grab all Positions that has the same department as the one that is being inserted
            List<Position__c> poss = [SELECT Id FROM Position__c WHERE Department__c = :role.Department__c];
            
            for(Position__c pos : poss) {
            
                Position__Share posShare = new Position__Share();
                posShare.ParentId = pos.Id;
                posShare.UserOrGroupId = role.User__c;
                posShare.AccessLevel = 'edit';
                posShare.RowCause = Schema.Position__Share.RowCause.Authenticated_Site_Sharing_Access__c;
                posShares.add(posShare);
                
            
            }           
            
        }
            
        // Insert all of the newly created Share records and capture save result 
        Database.SaveResult[] appShareInsertResult = Database.insert(appShares,false);
        Database.SaveResult[] posShareInsertResult = Database.insert(posShares,false);
    }
}