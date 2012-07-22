public with sharing class EricUploadController {
 
  public Document document {
    get {
      if (document == null)
        document = new Document();
      return document;
    }
    set;
  }
 
  public PageReference upload() {
    //String tmp = uploadResumeFile();
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, document.ContentType));
    return null;
  }
  
  public String uploadResumeFile() {
	  String ENDPOINT = 'https://api.box.com/2.0/files/data'; //'http://requestb.in/zeh4ozze';
	  String REPOS_FOLDER_ID = '323197723';
	  String API_KEY='q2m5pg738dgekmll3knx55tyxnf15ro6';
      String AUTH_TOKEN='6xxg77jzts0z5jg5gy29qzdqjct9hl0z';
      String AUTH_STRING = 'BoxAuth api_key='+API_KEY+'&auth_token='+AUTH_TOKEN;
  
  
	  Http httpCallout = new Http();
      HttpRequest requestBox = new HttpRequest();
    
      requestBox.setEndpoint(ENDPOINT);
      requestBox.setMethod('GET');
      requestBox.setHeader('Authorization', AUTH_STRING);
      //request
    
      HttpResponse res;
    
      try { 
        res = httpCallout.send(requestBox);
      } catch(System.CalloutException e) {
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Error: ' + e));
      }   
	  return 'Hello';
  }
 
}