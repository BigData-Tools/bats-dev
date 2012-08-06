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
        return null;
    }

   
    public String getBoxDescription() {
        try {
            return [SELECT body FROM EmailTemplate WHERE Name =: 'Box Company Description'].body;
        } catch (System.QueryException e) {
            return 'Box';        
        }
    }
}