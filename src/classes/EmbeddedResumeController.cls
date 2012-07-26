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
	    }   
	    Dom.Document domDoc = res.getBodyDocument();
	    embedHtml = domDoc.getRootElement().getChildElement('file_embed_html', null).getText();
    }
}