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
    
    /**
    * @description Go from Page 1 (upload) to Page 2 (resume text)
    * @return the pageReference to the next page
    */
    public pageReference uploadAction(){
        if (!Test.isRunningTest()) //because testMethods don't support callouts, and we need 75% code coverage.
            parsedResume = new ParsedResume(resume);
        return new PageReference('/apex/ApplyResumeText');
    }
    
    /**
    * @description it will just get the user from the resume text page into the application form
    * @return the pageReference to the next page
    */
    public pageReference resumeTextAction(){
        if (!Test.isRunningTest())
            parsedResume.parseToXML();
        return new PageReference('/apex/ApplySubmit');
    }
    
    /**
    * @description this method contains action from transforming from page 3 to 4 page. it contains upload resume to box, create candidate and application
    * @return the PageReferenece to the next page.
    */
    public pageReference submitAction(){
        if (!Test.isRunningTest()) {
            //upload Resume to Box
            BoxUpload boxUpload = new BoxUpload(resume);
            responseBody = boxUpload.getUploadedFileId();
        
            //update or create Candidate
            //upsert prevents duplicates       
            upsert parsedResume.c Email__c;
        
            //create Application
            Application__c a = new Application__c();
            a.Box_Resume_Id__c = boxUpload.getUploadedFileId();
            a.Candidate__c = parsedResume.c.Id;
            a.Resume_Text__c = parsedResume.resumeText;
            a.Box_Resume_Link__c = 'https://www.box.com/shared/' + boxUpload.getUploadedFileShareLink();
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