public with sharing class BoxUpload {
    
    private HttpResponse boxResponse; 
    
    private final String API_KEY = 'q2m5pg738dgekmll3knx55tyxnf15ro6'; //Box API
    private final String PUBLIC_USER_TOKEN = '6xxg77jzts0z5jg5gy29qzdqjct9hl0z'; //Box API
    private final String BOX_API_FILES_URL = 'https://commentboxats.appspot.com/forward_resume'; //Proxy to Box API
    private final String REPOS_FOLDER_ID = '323197723'; //ID of Folder where the Resumes will be stored
            
    public String getUploadedFileId(){
    	return getJsonField('id');
    }
    
    /* helper method to retrieve the value of a JSON field
     * param keyName: the name of the JSON field value to retrieve 
     */    
    private String getJsonField(String keyName){
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
    
    /* Uploads a resume file to box.
     * Uses a GAE proxy to handle the base64 encoding.
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
        }   
        boxResponse = res;
        checkSuccessfulUpload();
        return;
    }
            
    private void checkSuccessfulUpload() {
    	if (getJsonField('type') == 'error') {    		
    		throw new UploadException('There was an error uploading your resume: ' + getJsonField('message'));
    	}
    }
}