public class PositionsDynamicCall{
   
   public PositionsDynamicCall(){
   
   }
   
   public String receivedParameter{
       public get;
       public set;
   }

   public String getPositions(){
       String department = Apexpages.currentPage().getParameters().get('department');  
       String result = '';
       if(department != null){
            for (Position__c positionItem : [select Name from Position__c where Department__c =:department]){
                result += '<option value="' + positionItem.Name + '">' + positionItem.Name + '</option>';
            }
       }else{
           result += '<option value="">None</option>';
       }
       return result;
   }
   
   public void setPosition(String positions){
   
   }
   
    /*------------ Tests only below this line ------------*/
    static testMethod void testPositionsDynamicCall(){
        PositionsDynamicCall pdc = new PositionsDynamicCall();
        String tmp;
        tmp = pdc.getPositions();
        pdc.setPosition('pos');
        
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
        
        PageReference pageRef = Page.ApplyUpload;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('department', 'Engineering');
        tmp = pdc.getPositions();
    }
}