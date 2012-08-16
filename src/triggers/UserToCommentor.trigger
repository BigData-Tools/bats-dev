trigger UserToCommentor on User (after insert,after update) {

for(User user : trigger.new){

    Commentor__c commentor = new Commentor__c(User__c = user.Id, First_Name__c = user.FirstName, Last_Name__c = user.LastName, Email__c = user.Email);
    upsert commentor Email__c;
}

}