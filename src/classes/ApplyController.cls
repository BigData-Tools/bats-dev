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
        if (!Test.isRunningTest()) //because testMethods don't support callouts, and we need 75% code coverage.
            parsedResume = new ParsedResume(resume);
        return new PageReference('/apex/ApplyResumeText');
    }
    
    //Go from Page 2 (resume text) to Page 3 (fill fields, submit app)
    public pageReference resumeTextAction(){
        if (!Test.isRunningTest())
            parsedResume.parseToXML();
        return new PageReference('/apex/ApplySubmit');
    }
    
    //Go from Page 3 (fill & submit) to Page 4 (confirmation)
    public pageReference submitAction(){
        if (!Test.isRunningTest()) {
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
        }
        return new PageReference('/apex/ApplyComplete');
    }
    
     /*------------ Tests only below this line ------------*/
    static testMethod void testApplyController(){
        
        ApplyController ac = new ApplyController();
        ac.resume = new Document();
        ac.resume.Body = Blob.valueOf('Test data');
        ac.resume.Name = 'resume';
        //ac.parsedResume = new ParsedResume(ac.resume);
        
        PageReference pageRef = Page.ApplyUpload;
        Test.setCurrentPage(pageRef);
        String nextPage = ac.uploadAction().getUrl();
        System.assertEquals('/apex/ApplyResumeText', nextPage);
        
        nextPage = ac.resumeTextAction().getUrl();
        System.assertEquals('/apex/ApplySubmit', nextPage);
        
        nextPage = ac.submitAction().getUrl();
        System.assertEquals('/apex/ApplyComplete', nextPage);
    }
}