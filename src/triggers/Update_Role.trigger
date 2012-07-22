trigger Update_Role on Role__c (before update) {
    List<Application__Share> appShares = new List<Application__Share>();
    List<Position__Share> posShares = new List<Position__Share>();
    
    for (Role__c role : Trigger.new) {
    
        //Find all access that the user has and delete them
        List<Application__Share> oldAppShares = [SELECT Id from Application__Share WHERE RowCause = :Schema.Application__Share.RowCause.Authenticated_Site_Sharing_Access__c AND UserOrGroupId = :role.User__c];
        for (Application__Share oldAppShare : oldAppShares) {
        
            try {
                Delete oldAppShare;
            } catch(DmlException e) {
                System.debug(e.getMessage());
            
            }
        
        }
        
        List<Position__Share> oldPosShares = [SELECT Id from Position__Share WHERE RowCause = :Schema.Position__Share.RowCause.Authenticated_Site_Sharing_Access__c AND UserOrGroupId = :role.User__c];
        for (Position__Share oldPosShare : oldPosShares) {
        
            try {
                Delete oldPosShare;
            } catch(DmlException e) {
                System.debug(e.getMessage());
            
            }
        
        }
        
        
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
        
            
        // Insert all of the newly created Share records and capture save result 
        Database.SaveResult[] appShareInsertResult = Database.insert(appShares,false);
        Database.SaveResult[] posShareInsertResult = Database.insert(posShares,false);
        
        
    }    

}