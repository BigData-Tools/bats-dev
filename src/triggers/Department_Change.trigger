trigger Department_Change on Position__c (before update) {
     
    // Position_Share is the "Share" table that was created when the
    // Organization Wide Default sharing setting was set to "Private".
    // Allocate storage for a list of Position_Share records.
    List<Position__Share> posShares  = new List<Position__Share>();
    List<Application__Share> appShares  = new List<Application__Share>();

    // For each of the Position records being inserted, do the following:
    for(Position__c pos : trigger.new){
    
        // Delete the old sharing permissions
        List<Position__Share> oldPosShares = [SELECT Id FROM Position__Share WHERE ParentId = :pos.Id AND RowCause != :Schema.Position__Share.RowCause.Dept_Head_Hiring_Manager_Sharing_Access__c];
        
        for(Position__Share oldPosShare : oldPosShares) {
            try {
                Delete oldPosShare;
            } catch(DmlException e) {
                System.debug(e.getMessage());
            }
        }

        // Create a new Position__Share record to be inserted in to the Position__Share table.
        Position__Share deptShare = new Position__Share();
            
        // Populate the Position__Share record with the ID of the record to be shared.
        deptShare.ParentId = pos.Id;
            
        // Then, set the ID of user or group being granted access. In this case,
        // we’re setting the Id of the group for the department that is being set
        List<UserRole> roles = [SELECT Id from UserRole WHERE Name=:pos.Department__c];
        Id roleID = roles[0].Id;
        List<Group> groups = [SELECT g.Id FROM Group g WHERE Type='Role' and RelatedId=:roleID];
        deptShare.UserOrGroupId = groups[0].Id;
         
            
        // Specify that the Group should have edit access for 
        // this particular position record.
        deptShare.AccessLevel = 'edit';
            
        // Specify that the reason the department can edit the record.
        deptShare.RowCause = Schema.Position__Share.RowCause.Department_Sharing_Access__c;
            
        // Add the new Share record to the list of new Share records.
        posShares.add(deptShare);
        
        
        // We also have to add for authenticated site users
        List<Role__c> users = [SELECT Id,User__c FROM Role__c where Department__c = :pos.Department__c];
        for(Role__c role : users) {
            Position__Share posRoleShare = new Position__Share();
            posRoleShare.ParentId = pos.Id;
            posRoleShare.UserOrGroupId = role.User__c;
            posRoleShare.AccessLevel = 'edit';
            posRoleShare.RowCause = Schema.Position__Share.RowCause.Authenticated_Site_Sharing_Access__c;
            posShares.add(posRoleShare);
        }
        
        
        // Find all the applications that are tagged to this position and change the permissions accordingly.
        List<Application__c> apps = [SELECT Id from Application__c where Position__c = :pos.Id];
        List<Application__Share> oldAppShares = [SELECT Id FROM Application__Share WHERE RowCause = :Schema.Position__Share.RowCause.Department_Sharing_Access__c AND ParentId in (SELECT Id from Application__c where Position__c = :pos.Id)];
        
        // Delete the old sharing permissions
        for (Application__Share oldAppShare : oldAppShares) {
            try {
                Delete oldAppShare;
            } catch(DmlException e) {
                System.debug(e.getMessage());
            }
        }
        
        for(Application__c app : apps) {
            
            // Create a new Application__Share record to be inserted in to the Application_Share table.
            Application__Share appShare = new Application__Share();
                
            // Populate the Application__Share record with the ID of the record to be shared.
            appShare.ParentId = app.Id;
                
            // Then, set the ID of user or group being granted access. In this case,
            // we’re setting the group id of the department of the position that this
            // application is tagged to.
            appShare.UserOrGroupId = groups[0].Id;
             
                
            // Specify that the groupshould have edit access for 
            // this particular application record.
            appShare.AccessLevel = 'edit';
                
            // Specify that the reason the department can edit the record is 
            // because of position sharing access.
            appShare.RowCause = Schema.Application__Share.RowCause.Department_Sharing_Access__c;
                
            // Add the new Share record to the list of new Share records.
            appShares.add(appShare);           
            
            // We also have to add for authenticated site users
            //List<Role__c> users = [SELECT Id FROM Role__c where Department__c = :pos.Department__c];
            for(Role__c role : users) {
                Application__Share appRoleShare = new Application__Share();
                appRoleShare.ParentId = app.Id;
                appRoleShare.UserOrGroupId = role.User__c;
                appRoleShare.AccessLevel = 'edit';
                appRoleShare.RowCause = Schema.Application__Share.RowCause.Authenticated_Site_Sharing_Access__c;
                appShares.add(appRoleShare);
            }                 
        }
    }
        
    // Insert all of the newly created Share records and capture save result 
    Database.SaveResult[] posShareInsertResult = Database.insert(posShares,false);
    Database.SaveResult[] appShareInsertResult = Database.insert(appShares,false);
}