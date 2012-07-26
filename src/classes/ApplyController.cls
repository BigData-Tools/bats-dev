public with sharing class ApplyController {    
    
    public Document resume{
        get{
            if(resume == null){
                resume = new Document();
            }
            return resume;
        }
        set;
    }
        
    //for debug only
    public String responseBody{get; private set;}
    
    public ParsedResume parsedResume{get; private set;}    
    
    //Go from Page 1 (upload) to Page 2 (resume text)
    public pageReference uploadAction(){
        parsedResume = new ParsedResume(resume);
        return new PageReference('/apex/ApplyResumeText');
    }
    
    //Go from Page 2 (resume text) to Page 3 (fill fields, submit app)
    public pageReference resumeTextAction(){
        parsedResume.parseToXML();
        return new PageReference('/apex/ApplySubmit');
    }
    
    //Go from Page 3 (fill & submit) to Page 4 (confirmation)
    public pageReference submitAction(){
        //upload Resume to Box
        BoxUpload boxUpload = new BoxUpload(resume);
        responseBody = boxUpload.getUploadedFileId();
    
	    //create Candidate       
    	insert parsedResume.c;
    
        //create Application
        Application__c a = new Application__c();
        a.Box_Resume_Id__c = boxUpload.getUploadedFileId();
        a.Candidate__c = parsedResume.c.Id;
        a.Resume_Text__c = parsedResume.resumeText;
        a.Position__c = [SELECT Id FROM Position__c].get(0).Id;
        insert a;
        return new PageReference('/apex/ApplyComplete');
    }
}