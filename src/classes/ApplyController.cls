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
        try{
            parsedResume = new ParsedResume(resume);
        }catch(Exception e){
            //if the user didn't upload resume
        }
        return new PageReference('/apex/ApplyResumeText');
    }
    
    //Go from Page 2 (resume text) to Page 3 (fill fields, submit app)
    public pageReference resumeTextAction(){
        try{
            parsedResume.parseToXML();
        }catch(Exception e){
            //If the resume text wasn't there either because the applicant didn't supply their resume file or didn't paste
        }
        return new PageReference('/apex/ApplySubmit');
    }
    
    //Go from Page 3 (fill & submit) to Page 4 (confirmation)
    public pageReference submitAction(){
        //try{
            //upload Resume to Box
            BoxUpload boxUpload = new BoxUpload(resume);
	        responseBody = boxUpload.getUploadedFileId();
        
    	    //create Candidate       
        	insert parsedResume.c;
        
	        //create Application
            //TODO - implement this part.
         /*   
         }catch(Exception e){
             return null;
         }
         */
        return new PageReference('/apex/ApplyComplete');
    }
}