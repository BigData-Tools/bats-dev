public class SummarySidebarController{
 
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



 
static testMethod void testSummarySidebarController() {
Test.setCurrentPageReference(new PageReference('Page.SidebarSummary'));
SummarySidebarController controller = new SummarySidebarController();
Integer i1 = controller.getNewApplication();
Integer i2 = controller.getPhoneScreen();
Integer i3 = controller.getOnsite();

}
 
}