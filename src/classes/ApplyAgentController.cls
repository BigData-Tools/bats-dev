public with sharing class ApplyAgentController {
    
    public Document resume{
        get{
            if(resume == null){
                resume = new Document();
            }
            return resume;
        }
        set;
    }
    
    public String source{
        get;
        set;
    }
    
    private boolean validation(){
        try{
            if(!(resume.name.contains('.doc') || resume.name.contains('.docx') || resume.name.contains('.pdf'))){
                return false;
            }else if(source == null || source.length() < 1){
                return false;
            }
        }catch(Exception e){
            return false;
        }
        return true;
    }
    
    //for debug only
    public String responseBody{get; private set;}
    
    public ParsedResume parsedResume{get; private set;}    
    
    //Go from Page 1 (upload) to Page 2 (resume text)
    public pageReference uploadAction(){
        if(validation()){
            try{
                parsedResume = new ParsedResume(resume);
                BoxUpload boxUpload = new BoxUpload(resume);
                responseBody = boxUpload.getUploadedFileId();
                parsedResume.parseToXML();
                parsedResume.c.Source__c = source;
                insert parsedResume.c;
            }catch(Exception e){
                //if the user didn't upload resume
                return null;
            }
            return new PageReference('/apex/ApplyComplete');
        }else if(resume != null){
            ApexPages.Message fileNameMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'invalid file type');
            ApexPages.addMessage(fileNameMessage);   
        }
        return null;
    }
    
     /*------------ Tests only below this line ------------*/
    static testMethod void testApplyAgentController(){
        ApplyAgentController ttt = new ApplyAgentController();
        ttt.validation();
        ttt.uploadAction();
    
    }
}