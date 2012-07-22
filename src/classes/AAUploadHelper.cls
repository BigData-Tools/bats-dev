public class AAUploadHelper{
    
    public AAUploadHelper(Document document){
        HttpResponse res = uploadToBox(BOX_API_FILES_URL, document);
    }
    
    public AAUploadHelper(){
    
    }
    
    String BOX_API_URL = 'https://api.box.com/2.0';
    String BOX_API_FOLDER_URL= 'https://api.box.com/2.0/folders/0';
    String BOX_API_FILES_URL= 'https://api.box.com/2.0/files/data';
    String REPOS_FOLDER_ID = '323197723';
  
    final private String API_KEY = 'q2m5pg738dgekmll3knx55tyxnf15ro6';
    final private String PUBLIC_USER_TICKET = 'i45p3gc4b391n6iy16dcrmtmbk2yuj68';
    final private String PUBLIC_USER_TOKEN = '6xxg77jzts0z5jg5gy29qzdqjct9hl0z';
    String conbined = 'BoxAuth api_key=' + API_KEY + '&auth_token=' + PUBLIC_USER_TOKEN;
  
  
    /*private String generateDocumentLink(){
        return document.Url;
    }*/
  
    private String generateLinkOnBox(HttpResponse res){
        String fileId;
        JSONParser parser = JSON.createParser(res.getBody());
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                String fieldName = parser.getText();
                parser.nextToken();
                if(fieldName == 'id') {
                    fileId = parser.getText();
                } 
            }
        } 
          return 'not found';
    }
  
    private HttpResponse getBoxFolderInfo(String url){
        String BOX_API_FOLDER_URL = 'https://api.box.com/2.0/folders/0';
        Http httpCallout = new Http();
        HttpRequest requestBox = new HttpRequest();
        requestBox.setEndpoint(BOX_API_FOLDER_URL);
        requestBox.setMethod('GET');
        requestBox.setHeader('api_key', API_KEY);
        requestBox.setHeader('auth_token', PUBLIC_USER_TOKEN);
        HttpResponse res;
        try { 
            res = httpCallout.send(requestBox);
        } catch(System.CalloutException e) {
            System.debug('Callout ERROR: '+ e);
        }   
        return res;
    }
  
    public HttpResponse uploadToBox(String url, Document doc){
        /*
        curl https://api.box.com/2.0/files/data \
        -H "Authorization: BoxAuth api_key=API_KEY&auth_token=AUTH_TOKEN" \
        -F filename1=@FILE_NAME1 \
        -F filename2=@FILE_NAME2 \
        -F folder_id=FOLDER_ID
        */
    
        String BOX_API_FILES_URL = 'https://api.box.com/2.0/files/data';
        String REPOS_FOLDER_ID = '323197723';
        Http httpCallout = new Http();
        HttpRequest requestBox = new HttpRequest();
        requestBox.setEndpoint(url);
        requestBox.setMethod('POST');
        requestBox.setHeader('Authorization', conbined);
    
        //multipart form post
        String p_fileName = doc.Name;
        String p_fileContentType = doc.ContentType;
    
        String boundary = '_---------------------------7d4a6d158c9';
        String content = 'Content:\r\n--' + boundary + '\r\n';
    
        content += 'Content-Disposition:form-data;name="' + p_fileName + 
                        '";filename="'+p_fileName+'"\r\n';
        content +='Content-Type:' + p_fileContentType + ',charset=ISO-8859-1,*,utf-8\r\n';
        content +='Content-Transfer-Encoding: base64\r\n\r\n';
        content += doc.body.toString()+'\r\n';
        content += '--'+boundary+'\r\n';
        content += 'Content-Disposition:form-data;name="folder_id";FOLDER_ID="'+REPOS_FOLDER_ID+'"\r\n\r\n';
        content += REPOS_FOLDER_ID+'\r\n';
        content += '--'+boundary+'--\r\n\r\n';
        requestBox.setHeader('Content-Type','multipart/form-data;boundary=' + boundary);
        requestBox.setBody(content);
        HttpResponse res;
        try{ 
            res = httpCallout.send(requestBox);
        }catch(System.CalloutException e){
            System.debug('Callout ERROR: '+ e);
        }   
     return res;
  }
}