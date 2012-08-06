trigger Permission_Share on PositionUserAssociation__c (after insert, before delete) {

    List<Position__Share> posShares  = new List<Position__Share>();
    List<Application__Share> appShares = new List<Application__Share>();
    
    Map<Id, PositionUserAssociation__c> positionsIdMap;
    Map<Id, PositionUserAssociation__c> oldPositionsIdMap;
    
    Set<Id> posToDelete = new Set<Id>();
    Set<Id> commentorsToDelete = new Set<Id>();

    if (trigger.isInsert) {
        
        positionsIdMap = new Map<Id, PositionUserAssociation__c> ([select id, Position__c, Commentor__r.User__c from PositionUserAssociation__c where id in :Trigger.newMap.keySet()]);             
            
    }
    
    if (trigger.isDelete) {
        oldPositionsIdMap  = new Map<Id, PositionUserAssociation__c> ([select id, Position__c, Commentor__r.User__c from PositionUserAssociation__c where id in :Trigger.oldMap.keySet()]);                                                                   
    }
    
    List<PositionUserAssociation__c> puas = (Trigger.isDelete)?Trigger.old:Trigger.new;                                                                                             
    Integer i = 0;
    
    for (PositionUserAssociation__c pua : puas) {
        if (trigger.isInsert) {
            Position__Share posShr = new Position__Share(ParentId = pua.Position__c,
                                                                 UserOrGroupId = positionsIdMap.get(pua.Id).Commentor__r.User__c,
                                                                 AccessLevel = 'edit',
                                                                 RowCause = Schema.Position__Share.RowCause.Dept_Head_Hiring_Manager_Sharing_Access__c);
            posShares.add(posShr);
            
            //add all current applications with this new position share
            List<Application__c> apps = [SELECT Id from Application__c WHERE Position__c =: pua.Position__c];
            for (Application__c app : apps) {
                Application__Share appShr = new Application__Share(ParentId = app.Id,
                                                                        UserOrGroupId = positionsIdMap.get(pua.Id).Commentor__r.User__c,
                                                                        AccessLevel = 'edit',
                                                                        RowCause = Schema.Application__Share.RowCause.Dept_Head_Hiring_Manager_Sharing_Access__c);
            appShares.add(appShr);
            }
            
            
        } else if (trigger.isDelete) {
                                                                         
            commentorsToDelete.add(oldPositionsIdMap.get(pua.Id).Commentor__r.User__c);
            posToDelete.add(pua.Position__c);

        }
        
        i++;      

        
    }
    
    if (commentorsToDelete.size() > 0) {
        Position__Share[] sharesToDelete = [select id from Position__Share where parentid in :posToDelete and
                                            UserOrGroupId in :commentorsToDelete and
                                            RowCause = :Schema.Position__Share.RowCause.Dept_Head_Hiring_Manager_Sharing_Access__c];
        delete sharesToDelete;
        
        Application__Share[] appsToDelete = [SELECT id from Application__Share where parentid in (SELECT id from Application__c where Position__c in :posToDelete) and UserOrGroupId in :commentorsToDelete and
                                            RowCause = :Schema.Application__Share.RowCause.Dept_Head_Hiring_Manager_Sharing_Access__c];
        delete appsToDelete;                     
    }    
       
    if (posShares.size() > 0) {
        insert posShares; 
    }  
 
     if (appShares.size() > 0) {
        insert appShares; 
    }  
}