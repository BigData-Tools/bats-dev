public class PositionParamController
{
    private String name;
    private Position__c p;
    
    public String getName() {
       name = System.currentPagereference().getParameters().get('positionName');
        return name;
    }
    
    public PositionParamController(ApexPages.StandardController stdController) {
    
      p = [SELECT Department__c,Location__c,Description__c FROM Position__c WHERE Name=:this.getName()].get(0);
    }
    
    public String getDescription() {
     return p.Description__c;
     }
     
     public String getLocation()  {
      
      return p.Location__c;
    }
    
     public String getDepartment()  {
      
      return p.Department__c;
    }
    
    public PageReference applyButtonClick() {
        PageReference pageRef = new PageReference('/apex/ApplyUpload');
        pageRef.getParameters().put('positionName',name);
        return PageRef;
    }

   
    public String getBoxDescription() {
        try {
            return [SELECT body FROM EmailTemplate WHERE Name =: 'Box Company Description'].body;
        } catch (System.QueryException e) {
            return 'Box';        
        }
    }
    
    /*------------ Tests only below this line ------------*/
    static testMethod void testPositionParamController(){
        Application__c a = new Application__c();
        ApexPages.StandardController sc = new ApexPages.standardController(a);
        
        PageReference pageRef = Page.ApplyUpload;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('positionName', 'positionName');
                
        Candidate__c c = new Candidate__c();      
        c.First_Name__c = 'user';
        c.Last_Name__c = 'user';
        c.Email__c = 'user@user.com';
        insert c;      
      
        User u = [SELECT Id FROM User].get(0);
      
        Position__c p = new Position__c();
        p.Department__c = 'Engineering';
        p.Name = 'positionName';
        p.Number_of_Hires__c = 5;
        p.Hiring_Manager__c = u.Id;
        p.Recruiter__c = u.Id; 
        p.Coordinator__c = u.Id; 
        p.Open_Date__c = System.today();
        p.Close_Date__c = System.today();
        insert p;
        
        PositionParamController ppc = new PositionParamController(sc);
        
        String tmp;
        tmp = ppc.getName();
        tmp = ppc.getBoxDescription();
        tmp = ppc.getDepartment();
        tmp = ppc.getDescription();
        tmp = ppc.getLocation();
        
        PageReference prTmp;
        prTmp = ppc.applyButtonClick();
    }
}