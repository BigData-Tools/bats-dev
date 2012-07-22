trigger Status_Offer_Accepted on Application__c (after update) {
    for(Application__c app : Trigger.new){
    
        if (app.Status__c == 'Offer Accepted') {
            List<Application__Share> oldAppShares = [SELECT Id FROM Application__Share WHERE ParentId = :app.Id];
            
            for(Application__Share oldAppShare : oldAppShares) {
                try {
                    Delete oldAppShare;
                } catch(DmlException e) {
                    System.debug(e.getMessage());
                    
                }
            }
        }
    
    }


}