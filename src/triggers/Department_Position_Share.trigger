trigger Department_Position_Share on Position__c (after insert) {
   // We only execute the trigger after a Position record has been inserted 
    // because we need the Id of the Position record to already exist.
    if(trigger.isInsert){
     
    // Position_Share is the "Share" table that was created when the
    // Organization Wide Default sharing setting was set to "Private".
    // Allocate storage for a list of Position_Share records.
    List<Position__Share> posShares  = new List<Position__Share>();

    // For each of the Position records being inserted, do the following:
    for(Position__c pos : trigger.new){

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
        
    }
        
    // Insert all of the newly created Share records and capture save result 
    Database.SaveResult[] posShareInsertResult = Database.insert(posShares,false);
        
    }
 
}