trigger Delete_Role on Role__c (before delete) {

    if (trigger.IsDelete) {
        for (Role__c role : Trigger.old) {
        
            //Find all access that the user has
            List<Application__Share> appShares = [SELECT Id from Application__Share WHERE RowCause = :Schema.Application__Share.RowCause.Authenticated_Site_Sharing_Access__c AND UserOrGroupId = :role.User__c];
            for (Application__Share appShare : appShares) {
            
                try {
                    Delete appShare;
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
        }    
    }
   
}