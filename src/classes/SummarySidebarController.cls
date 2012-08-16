public class SummarySidebarController{

public Integer getNewReview() {
return [
SELECT count() FROM Review__c
WHERE CreatedDate<=NEXT_WEEK  AND (Application__r.Recruiter__c = :UserInfo.getUserId() OR Application__r.Hiring_Manager__c = :UserInfo.getUserId() OR Application__r.Coordinator__c = :UserInfo.getUserId())
];
}
public Integer getNewPosition() {
return [
SELECT count() FROM Position__c
WHERE CreatedDate<=NEXT_WEEK  AND (Recruiter__c = :UserInfo.getUserId() OR Hiring_Manager__c = :UserInfo.getUserId() OR Coordinator__c = :UserInfo.getUserId())
];
}
public Integer getNewApplication() {
return [
SELECT count() FROM Application__c
WHERE Status__c='New' AND (Recruiter__c = :UserInfo.getUserId() OR Hiring_Manager__c = :UserInfo.getUserId() OR Coordinator__c = :UserInfo.getUserId())
];
}
 
public Integer getPhoneScreen() {
return [
SELECT count() FROM Application__c
WHERE (Status__c='Recruiter Screen' OR Status__c='HM Screen')  AND (Recruiter__c = :UserInfo.getUserId() OR Hiring_Manager__c = :UserInfo.getUserId() OR Coordinator__c = :UserInfo.getUserId())
];
}
 
public Integer getOnsite() {
return [
SELECT count() FROM Application__c
WHERE Status__c='Onsite Interview'  AND (Recruiter__c = :UserInfo.getUserId() OR Hiring_Manager__c = :UserInfo.getUserId() OR Coordinator__c = :UserInfo.getUserId())
];
}


 /*------------ Tests only below this line ------------*/
    static testMethod void testSummarySidebarController(){
    SummarySidebarController ttt = new SummarySidebarController();
      ttt.getNewReview();
      ttt.getNewPosition();
      ttt.getNewApplication();
      ttt.getPhoneScreen();
      ttt.getOnsite();
    }

 
}