trigger New_Review_Update_Interview_Datetime on Review__c (before insert) {
    for(Review__c review : Trigger.new){
    
        // Update the interview date/time for specific review
        Interview__c inter = [Select Id, Last_Interview_Datetime__c from Interview__c where Id =: review.Interview__c].get(0); 
        review.Interview_Datetime__c = inter.Last_Interview_Datetime__c;
    
    }
}