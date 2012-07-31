public class SummarySidebarController{

public Integer getNewGoal() {
return [
select count() from Goal__c
where CreatedDate<=NEXT_WEEK
];
}
public Integer getNewReview() {
return [
select count() from Review__c
where CreatedDate<=NEXT_WEEK
];
}
public Integer getNewPosition() {
return [
select count() from Position__c
where CreatedDate<=NEXT_WEEK
];
}
public Integer getNewApplication() {
return [
select count() from Application__c
where Status__c='New'
];
}
 
public Integer getPhoneScreen() {
return [
select count() from Application__c
where Status__c='Recruiter Screen'
OR Status__c='HM Screen'
];
}
 
public Integer getOnsite() {
return [
select count() from Application__c
where Status__c='Onsite Interview'
];
}



 /*
static testMethod void testSummarySidebarController() {
Test.setCurrentPageReference(new PageReference('Page.SidebarSummary'));
SummarySidebarController controller = new SummarySidebarController();
Integer i1 = controller.getNewApplication();
Integer i2 = controller.getPhoneScreen();
Integer i3 = controller.getOnsite();
Integer i4 = controller.getNewGoal();
Integer i5 = controller.getNewReview();
Integer i6 = controller.getNewPosition();

}
*/
 /*------------ Tests only below this line ------------*/
    static testMethod void testSummarySidebarController(){
    SummarySidebarController ttt = new SummarySidebarController();
      ttt.getNewGoal();
      ttt.getNewReview();
      ttt.getNewPosition();
      ttt.getNewApplication();
      ttt.getPhoneScreen();
      ttt.getOnsite();
    }

 
}