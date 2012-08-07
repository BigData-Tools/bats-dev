public with sharing class BoxUpload {
    
    private HttpResponse boxResponse; 
    
    private String sharedLink;
    
    private final String API_KEY = 'q2m5pg738dgekmll3knx55tyxnf15ro6'; //Box API
    private final String PUBLIC_USER_TOKEN = '6xxg77jzts0z5jg5gy29qzdqjct9hl0z'; //Box API
    private final String BOX_API_FILES_URL = 'https://commentboxats.appspot.com/forward_resume'; //Proxy to Box API
    private final String REPOS_FOLDER_ID = '323197723'; //ID of Folder where the Resumes will be stored
            
    public String getUploadedFileId(){
        return getJsonField('id');
    }
    
    public String getUploadedFileShareLink(){
    	return sharedLink;
    }
    
    /* 
     * @description helper method to retrieve the value of a XML field
     * @param xml the XML string to parse 
     * @param keyName the name of the XML field value to retrieve 
     */    
    private String getXMLField(String xml, String keyName){        
        if (Test.isRunningTest())
            return 'null_for_test';        
		DOM.Document doc = new DOM.Document();      
		try {
		    doc.load(xml);    
		    DOM.XMLNode root = doc.getRootElement();
		    return root.getChildElement(keyName, null).getText();
		  } catch (System.XMLException e) {  // invalid XML
		    return e.getMessage();
		  }
    }
    
    /* 
     * @description helper method to retrieve the value of a JSON field
     * @param keyName the name of the JSON field value to retrieve 
     */    
    private String getJsonField(String keyName){        
        if (Test.isRunningTest())
            return 'not found';
        JSONParser parser = JSON.createParser(boxResponse.getBody());
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                String fieldName = parser.getText();
                parser.nextToken();
                if(fieldName == keyName) {
                    return parser.getText();
                } 
            }
        } 
        return 'not found';
    }
    
    /** 
     * @description Uploads a resume file to box. Uses a GAE proxy to handle the base64 encoding.
     * @param document is the document we will upload
     */
    public BoxUpload(Document doc){
        Http httpCallout = new Http();
        HttpRequest requestBox = new HttpRequest();
        requestBox.setEndpoint(BOX_API_FILES_URL);
        requestBox.setMethod('POST');
        requestBox.setHeader('Authorization', 'BoxAuth api_key=' + API_KEY + '&auth_token=' + PUBLIC_USER_TOKEN);
        requestBox.setHeader('Content-Type','multipart/form-data');
        requestBox.setHeader('FOLDER_ID', REPOS_FOLDER_ID);
        requestBox.setHeader('FILENAME', String.valueOf(System.now().getTime()) + '_' + doc.Name); //prepend UNIX time to avoid naming conflicts

        String content = EncodingUtil.base64Encode(doc.body);
        requestBox.setBody(content);
        HttpResponse res;
        try{ 
            res = httpCallout.send(requestBox);
        }catch(System.CalloutException e){
            System.debug('Callout ERROR: '+ e);
        }catch(System.TypeException e) {} //because salesforce tests don't support callouts
        boxResponse = res;
        checkSuccessfulUpload();
        shareResume();
        return;
    }
            
    private void checkSuccessfulUpload() {
        if (getJsonField('type') == 'error') {          
            throw new UploadException('There was an error uploading your resume: ' + getJsonField('message'));
        }
    }
    
    private void shareResume() {
        // https://www.box.net/api/1.0/rest?action=public_share&api_key=rrc1d3ntb53tt6b2vhail6rdtrsxov3v&auth_token=rpuis3lincpbyz60gyym8s3xhnc6gbcl&target=folder&target_id=709&password=&message=hey&emails[]=email@example.com&emails[]=email2@example.com
        // https://www.box.net/api/1.0/rest?action=private_share&api_key=q2m5pg738dgekmll3knx55tyxnf15ro6&auth_token=6xxg77jzts0z5jg5gy29qzdqjct9hl0z&target=file&target_id=2709767190&emails[]=email@example.com&message=hey&notify=false
        try { 
            Http httpCallout = new Http();
            HttpRequest requestBox = new HttpRequest();
            String fileId = getJsonField('id');
            requestBox.setEndpoint('https://www.box.net/api/1.0/rest?action=public_share&api_key=' + API_KEY + '&auth_token=' + PUBLIC_USER_TOKEN + '&target=file&target_id=' + fileId + '&password=&message=hey&emails[]=email@box.com&message=hey&notify=false');
            requestBox.setMethod('GET');        
            HttpResponse res = httpCallout.send(requestBox);
            Dom.Document domDoc = res.getBodyDocument();
            sharedLink = domDoc.getRootElement().getChildElement('public_name', null).getText();
        }catch(System.TypeException e) {}
    }
    
     /*------------ Tests only below this line ------------*/
    static testMethod void testBoxUpload(){
        Document d = new Document();
        d.Body = Blob.valueOf('test data');
        BoxUpload bu = new BoxUpload(d);        
        bu.getJsonField('type');
        bu.checkSuccessfulUpload();
        bu.shareResume();
        bu.getUploadedFileId();
    }
}