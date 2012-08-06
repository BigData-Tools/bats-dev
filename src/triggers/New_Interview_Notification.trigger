trigger New_Interview_Notification on Interview__c (before insert) {

    for(Interview__c interview : Trigger.new){
    
        interview.Last_Interview_Datetime__c = interview.Interview_Datetime__c;
    
    }
}