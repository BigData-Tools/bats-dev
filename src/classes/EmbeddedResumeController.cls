public with sharing class EmbeddedResumeController {
    
    private String ENDPOINT = 'http://box.net/api/1.0/rest?action=create_file_embed';
    private String API_KEY = 'q2m5pg738dgekmll3knx55tyxnf15ro6'; //Same credentials work for v1 and v2 of box API
    private String AUTH_TOKEN = '6xxg77jzts0z5jg5gy29qzdqjct9hl0z'; // Box API
   
    public String embedHtml { get; private set; }
    
    public EmbeddedResumeController(ApexPages.StandardController stdController) {
        Id applicationId = stdController.getId();
        try {
           Application__c a = [SELECT Box_Resume_Id__c FROM Application__c WHERE Id = :applicationId].get(0);
           fetchEmbedHtml(a.Box_Resume_Id__c);
        } catch (Nullpointerexception e) {
           embedHtml = 'Couldn\'t find resume file. Null Exception.';
           return;
        }
    }
            
    public void fetchEmbedHtml(String fileId){
        ENDPOINT += '&api_key=' + API_KEY + '&auth_token=' + AUTH_TOKEN + '&file_id=' + fileId;
        Http httpCallout = new Http();
        HttpRequest requestBox = new HttpRequest();
        requestBox.setEndpoint(ENDPOINT);
        requestBox.setMethod('GET');
        HttpResponse res;
        try{ 
            res = httpCallout.send(requestBox);
        }catch(System.CalloutException e){
            embedHtml = ('Callout ERROR: '+ e);
            return;
        }catch(System.TypeException e) {} //because salesforce tests don't support callouts   
        Dom.Document domDoc = res.getBodyDocument();
        embedHtml = domDoc.getRootElement().getChildElement('file_embed_html', null).getText();
    }
    
      /*------------ Tests only below this line ------------*/
    static testMethod void testEmbeddedResumeController(){
      Application__c a = new Application__c();
      
      Candidate__c c = new Candidate__c();      
      c.First_Name__c = 'user';
      c.Last_Name__c = 'user';
      c.Email__c = 'user@user.com';
      insert c;      
      
      User u = [SELECT Id FROM User].get(0);
      
      Position__c p = new Position__c();
      p.Department__c = 'Engineering';
      p.Number_of_Hires__c = 5;
      p.Hiring_Manager__c = u.Id;
      p.Recruiter__c = u.Id; 
      p.Coordinator__c = u.Id; 
      p.Open_Date__c = System.today();
      p.Close_Date__c = System.today();      
      insert p;
            
      a.Box_Resume_Id__c = 'boxid';
      a.Candidate__c = c.Id;
      a.Position__c = p.Id;
      insert a;
      ApexPages.StandardController sc = new ApexPages.standardController(a);      
      EmbeddedResumeController erc = new EmbeddedResumeController(sc);          
    }
}