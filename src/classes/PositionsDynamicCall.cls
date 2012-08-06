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
}