trigger Permission_Share on PositionUserAssociation__c (after insert) {

   // We only execute the trigger after a Position record has been inserted 
    // because we need the Id of the Position record to already exist.
    if(trigger.isInsert){
    
    System.debug('we are in trigger');
    
    // Position_Share is the "Share" table that was created when the
    // Organization Wide Default sharing setting was set to "Private".
    // Allocate storage for a list of Position_Share records.
    List<Position__Share> posShares  = new List<Position__Share>();

    // For each of the PositionUserAssociation records being inserted, do the following:
    for(PositionUserAssociation__c pua : trigger.new){
        System.debug('we are in again');
        // Create a new Position__Share record to be inserted in to the Position__Share table.
        Position__Share posShare = new Position__Share();
            
        // Populate the Position__Share record with the ID of the record to be shared.
        posShare.ParentId = pua.Position__c;
        System.debug(pua.Position__c);
        posShare.UserOrGroupId = pua.Commentor__r.User__c;
        System.debug(pua.Commentor__r.User__c);
        posShare.AccessLevel = 'edit';
        posShare.RowCause = Schema.Position__Share.RowCause.Dept_Head_Hiring_Manager_Sharing_Access__c;

        posShares.add(posShare);
        
    }
        
    // Insert all of the newly created Share records and capture save result 
    Database.SaveResult[] posShareInsertResult = Database.insert(posShares,false);
        
    }
 
}