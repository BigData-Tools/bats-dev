public class DashboardRedZoneController{

public Integer getOfferInProgressNum() {
    return [select count() from Application__c where Status__c='Offer in process' and CreatedDate<=NEXT_WEEK];
}

public Integer getCodeRedNum() {
    return [select count() from Candidate__c where Code_Red__c=true and CreatedDate<=NEXT_WEEK];
}


 /*------------ Tests only below this line ------------*/
    static testMethod void testDashboardRedZoneController(){
    DashboardRedZoneController t = new DashboardRedZoneController();
      t.getOfferInProgressNum();
      t.getCodeRedNum();      
    }

 
}