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
    
    //for debug only
    public String responseBody{get; private set;}
    
    public ParsedResume parsedResume{get; private set;}    
    
    //Go from Page 1 (upload) to Page 2 (resume text)
    public pageReference uploadAction(){
        try{
            parsedResume = new ParsedResume(resume);
            HttpResponse BoxResponse = BoxUpload.uploadToBox(resume);
            responseBody = BoxResponse.getBody();    
            insert parsedResume.c;
        }catch(Exception e){
            //if the user didn't upload resume
             return null;
        }
        return new PageReference('/apex/ApplyComplete');
    }
}