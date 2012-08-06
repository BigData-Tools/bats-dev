trigger Department_Share on Application__c (after insert) {
   // We only execute the trigger after an application record has been inserted 
    // because we need the Id of the application record to already exist.
    if(trigger.isInsert){
     
    // Application_Share is the "Share" table that was created when the
    // Organization Wide Default sharing setting was set to "Private".
    // Allocate storage for a list of Application__Share records.
    List<Application__Share> appShares  = new List<Application__Share>();

    // For each of the Application records being inserted, do the following:
    for(Application__c app : trigger.new){

        // Create a new Application__Share record to be inserted in to the Application_Share table.
        Application__Share appShare = new Application__Share();
            
        // Populate the Application__Share record with the ID of the record to be shared.
        appShare.ParentId = app.Id;
            
        // Then, set the ID of user or group being granted access. In this case,
        // we’re setting the group id of the department of the position that this
        // application is tagged to.
       
        List<Position__c> positions =[select Department__c from Position__c where Id =:app.Position__c];
        String dept = positions[0].Department__c;
        List<UserRole> roles = [SELECT Id from UserRole WHERE Name=:dept];
        Id roleID = roles[0].Id;
        List<Group> groups = [SELECT g.Id FROM Group g WHERE Type='Role' and RelatedId=:roleID];
        appShare.UserOrGroupId = groups[0].Id;
         
            
        // Specify that the groupshould have edit access for 
        // this particular application record.
        appShare.AccessLevel = 'edit';
            
        // Specify that the reason the department can edit the record is 
        // because of position sharing access.
        appShare.RowCause = Schema.Application__Share.RowCause.Department_Sharing_Access__c;
            
        // Add the new Share record to the list of new Share records.
        appShares.add(appShare);
        
        
        // We also have to add for authenticated site users (from custom roles)
        List<Role__c> users = [SELECT User__c,Id FROM Role__c where Department__c = :dept];
        for(Role__c role : users) {
            Application__Share appRoleShare = new Application__Share();
            appRoleShare.ParentId = app.Id;
            appRoleShare.UserOrGroupId = role.User__c;
            appRoleShare.AccessLevel = 'edit';
            appRoleShare.RowCause = Schema.Application__Share.RowCause.Authenticated_Site_Sharing_Access__c;
            appShares.add(appRoleShare);
        }
        
        // We also have to add for individual authenticated site users
        List<Position__Share> usersPos = [SELECT Id, UserOrGroupId FROM Position__Share WHERE ParentId =: app.Position__c AND RowCause =: Schema.Position__Share.RowCause.Dept_Head_Hiring_Manager_Sharing_Access__c];
        for (Position__Share pos : usersPos) {
            Application__Share appRoleShare = new Application__Share();
            appRoleShare.ParentId = app.Id;
            appRoleShare.UserOrGroupId = pos.UserOrGroupId;
            appRoleShare.AccessLevel = 'edit';
            appRoleShare.RowCause = Schema.Application__Share.RowCause.Dept_Head_Hiring_Manager_Sharing_Access__c;
            appShares.add(appRoleShare);            
        }
    }
        
    // Insert all of the newly created Share records and capture save result 
    Database.SaveResult[] posShareInsertResult = Database.insert(appShares,false);
        
    }
 
}