public with sharing class FileUploadController {
     //--------------------------------------Kevin's Code--------------------------------------
  public Document document {
    get
    {      if (document == null)
        document = new Document();
      return document;}
    set;
  }
  
    /*
    private void StoreOnForce(){
    document.AuthorId = UserInfo.getUserId();
    document.FolderId = UserInfo.getUserId(); // put it in running user's folder
 
    try {
      insert document;
    } catch (DMLException e) {
      //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
      
    } finally {
      document.body = null; // clears the viewstate
      document = new Document();
    }
    }
    */
  
    
  String BOX_API_URL = 'https://api.box.com/2.0';
  String BOX_API_FOLDER_URL= 'https://api.box.com/2.0/folders/0';
  String BOX_API_FILES_URL= 'https://api.box.com/2.0/files/data';
  String REPOS_FOLDER_ID = '323197723';
  
  //public Http callout = new Http();
  //public HttpRequest requestBox = new HttpRequest();
  //public HttpResponse res;
  
  final private String API_KEY='q2m5pg738dgekmll3knx55tyxnf15ro6';
  final private String PUBLIC_USER_TICKET='i45p3gc4b391n6iy16dcrmtmbk2yuj68';
  final private String PUBLIC_USER_TOKEN='6xxg77jzts0z5jg5gy29qzdqjct9hl0z';
  String conbined = 'BoxAuth api_key='+API_KEY+'&auth_token='+PUBLIC_USER_TOKEN;
  
  
  private String generateDocumentLink(){
    return document.Url;
  }
  
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
      } return 'not found';
  }
  
  private HttpResponse getBoxFolderInfo(String url){
    
    String BOX_API_FOLDER_URL= 'https://api.box.com/2.0/folders/0';
    
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
  
  private HttpResponse uploadToBox(String url, Document doc){
    /*
    curl https://api.box.com/2.0/files/data \
    -H "Authorization: BoxAuth api_key=API_KEY&auth_token=AUTH_TOKEN" \
    -F filename1=@FILE_NAME1 \
    -F filename2=@FILE_NAME2 \
    -F folder_id=FOLDER_ID
    */
    
    String BOX_API_FILES_URL= 'https://api.box.com/2.0/files/data';
    String REPOS_FOLDER_ID = '323197723';
    
    Http httpCallout = new Http();
    HttpRequest requestBox = new HttpRequest();
    
    requestBox.setEndpoint(BOX_API_FILES_URL);
    
    requestBox.setMethod('POST');
    
    requestBox.setHeader('Authorization', conbined);
    //requestBox.setHeader('api_key', API_KEY);
    //requestBox.setHeader('auth_token', PUBLIC_USER_TOKEN);
    
    //multipart form post
    String p_fileName =doc.Name;
    String p_fileContentType= doc.ContentType;
    
    /*
        Content:
        --_---------------------------7d4a6d158c9
        Content-Disposition:form-data;name="p_fileName";filename="p_fileName"
        Content-Type: p_fileContentType,charset=ISO-8859-1,*,utf-8
        Content-Transfer-Encoding: base64
                
        Hello world!content of file
        
        --_---------------------------7d4a6d158c9
        Content-Disposition:form-data;name="folder_id"
        
        323197723
        
        --_---------------------------7d4a6d158c9
    
    */
    String boundary = '_---------------------------7d4a6d158c9';
    String content = 'Content:\r\n--' + boundary + '\r\n';
    
    content += 'Content-Disposition:form-data;name="' + p_fileName + 
                        '";filename="'+p_fileName+'"\r\n';
    content +='Content-Type:' + p_fileContentType + ',charset=ISO-8859-1,*,utf-8\r\n';
    content +='Content-Transfer-Encoding: base64\r\n\r\n';
    //content +='Content-Transfer-Encoding: binary\r\n\r\n';
    
    content += doc.body.toString()+'\r\n';
    //content += EncodingUtil.base64Encode(doc.Body) +'\r\n\r\n';
    
    content += '--'+boundary+'\r\n';
    
    content += 'Content-Disposition:form-data;name="folder_id" \r\n\r\n';
    //content +='Content-Type:' + 'text' + ',charset=ISO-8859-1,*,utf-8\r\n\r\n';
    //content +='Content-Transfer-Encoding: binary\r\n\r\n';
    content += '323197723'+'\r\n';
    content += '--'+boundary+'--\r\n\r\n';
    
    requestBox.setHeader('Content-Type','multipart/form-data;boundary='+boundary);
   
    //requestBox.setHeader('Content-Encoding','base64');
    //req.setHeader('Content-Encoding','binary');
    
    requestBox.setBody(content);
    
    HttpResponse res;
    
    try { 
        res = httpCallout.send(requestBox);
      } catch(System.CalloutException e) {
         System.debug('Callout ERROR: '+ e);
      }   
      
     return res;
  }
  
  
  public PageReference upload() {
    HttpResponse res=uploadToBox(BOX_API_FILES_URL,document);
    
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, res.getBody()  )); //box.getFolderTree('0', true)
    return null; //EncodingUtil.base64Encode(document.Body)
  }
 
 
  
 
 private HttpResponse uploadBoxAPIv1(String sUrl,Document doc){
        
        String p_fileName =doc.Name;
        
        String boundary = '---------------------------7d4a6d158c9';
        String content = 'Content:\r\n--' + boundary + '\r\nContent-Disposition:attachment;name="' + p_fileName + 
                        '";filename="'+p_fileName+'"\r\n';
        content +='Content-Type: '+doc.ContentType + ',charset=ISO-8859-1,*,utf-8\r\n';
        content +='Content-Transfer-Encoding: base64\r\n\r\n';
        //content +='Content-Transfer-Encoding: binary\r\n\r\n';
        
        //Blob b = doc.body; 
        //String s = b.toString(); 
        //content += s+'\r\n\r\n';
        //content += EncodingUtil.base64Encode(doc.Body)+'\r\n\r\n';
        content += doc.body.toString()+'\r\n\r\n';
        
        content += '--'+boundary+'\r\n';
        
        content += 'Content-Disposition:form-data;name="folder_id" \r\n';
        //content +='Content-Type:' + 'text' + ',charset=ISO-8859-1,*,utf-8\r\n';
        //content +='Content-Transfer-Encoding: binary\r\n\r\n';
        content += '323197723'+'\r\n';
        content += '--'+boundary+'--\r\n';
        

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        
        req.setHeader('Content-Type','multipart/form-data;boundary='+boundary);
        //req.setHeader('Content-Encoding','base64');
        //req.setHeader('Content-Encoding','binary');
        req.setEndpoint(sUrl);
        req.setMethod('POST');
        req.setBody(content);
        HttpResponse res;

        try { 
            res = h.send(req);
          } catch(System.CalloutException e) {
             System.debug('CalloutERROR: '+ e);
          }        
        return res;
    }
 
 
 
  public PageReference uploadv1() {
    
    String sUrl = 'http://upload.box.net/api/1.0/'+'upload'+'/'+'6xxg77jzts0z5jg5gy29qzdqjct9hl0z'+'/'+'323197723';
    HttpResponse res = uploadBoxAPIv1(sUrl,document);
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,res.toString()  )); //box.getFolderTree('0', true)
    return null; //EncodingUtil.base64Encode(document.Body)
  }
 

    
    //--------------------------------------Mohammad's Code--------------------------------------
    
    
    public String resumeText{
        get;
        set;
    }
    
    public Resume resume{
        get;
        set;
    }
    
    public pageReference convertToText(){
        PageReference page = new PageReference('/apex/TextResume');
        sovrenCom.ConvertAndParseSoap obj = new sovrenCom.ConvertAndParseSoap();
        String sovrenResponse = '';
        if(document.body.size() > 0){
            resumeText = obj.DoConversionSimplified(EncodingUtil.Base64Encode(document.body),'PLAIN_TEXT');
        }else{
            page = null;  
        }
        return page;  
    }
    
    public pageReference parseResume(){
        PageReference page = new PageReference('/apex/ApplicationForm');
        sovrenCom.ConvertAndParseSoap obj = new sovrenCom.ConvertAndParseSoap();
        String sovrenXML = obj.ParseConvertedResume(resumeText , false, false, 5000, 2,'1', false,'1');
        if(resume == null && sovrenXML != null){
            System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$' + sovrenXML);
            resume = new resume(sovrenXML);
        }
        //else{
            //System.debug('Was initiated before');
        //}
        return page;
    }
}