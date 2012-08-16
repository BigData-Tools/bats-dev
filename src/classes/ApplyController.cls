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
            
    public String responseBody{get; private set;} //for debug
    
    public ParsedResume parsedResume{get; private set;}    
    
    private String positionName;
    
    /**
    * @description Go from Page 1 (upload) to Page 2 (resume text)
    * @return the pageReference to the next page
    */
    public pageReference uploadAction(){
        List<ApexPages.Message> errorsList = validation();
        if (resume.name != null) {
            parsedResume = new ParsedResume(resume);
            positionName = System.currentPagereference().getParameters().get('positionName');
        }else{
            for(ApexPages.Message errorMessage : errorsList){
                ApexPages.addMessage(errorMessage);
            } 
            return null;
        }
        return new PageReference('/apex/ApplyResumeText');
    }
    
     private List<ApexPages.Message> validation(){
        List<ApexPages.Message> errorMessageList = new List<ApexPages.Message>();
        try{
            if(resume != null && resume.name == null){
                errorMessageList.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'resume is required'));
            }
            
            if(resume != null && resume.name != null && !(resume.name.contains('.doc') || resume.name.contains('.docx') || resume.name.contains('.pdf'))){
                errorMessageList.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'invalid file type'));
            }
        }catch(Exception e){
            errorMessageList.add(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return errorMessageList;
    }
    
    /**
    * @description it will just get the user from the resume text page into the application form
    * @return the pageReference to the next page
    */
    public pageReference resumeTextAction(){
        parsedResume.parseToXML();
        return new PageReference('/apex/ApplySubmit');
    }
    
    /**
    * @description this method contains action from transforming from page 3 to 4 page. it contains upload resume to box, create candidate and application
    * @return the PageReferenece to the next page.
    */
    public pageReference submitAction(){

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
        a.Position__c = [SELECT Id FROM Position__c WHERE name =: positionName].get(0).Id;
        insert a;

        return new PageReference('/apex/ApplyComplete');
    }
    
     /*------------ Tests only below this line ------------*/
    static testMethod void testApplyController(){
        ApplyController ac0 = new ApplyController();
        //first test upload without providing a resume
        ac0.uploadAction();
        
        //now provide resume and test everything
        PageReference pageRef = Page.ApplyUpload;
        pageRef.getParameters().put('positionName', 'positionName');
        Test.setCurrentPage(pageRef);        
        
        Candidate__c can = new Candidate__c();      
        can.First_Name__c = 'user';
        can.Last_Name__c = 'user';
        can.Email__c = 'user@user.com';
        insert can;
        
        User u = [SELECT Id FROM User].get(0);
      
        Position__c p = new Position__c();
        p.Department__c = 'Engineering';
        p.Name = 'positionName';
        p.Number_of_Hires__c = 5;
        p.Hiring_Manager__c = u.Id;
        p.Recruiter__c = u.Id; 
        p.Coordinator__c = u.Id; 
        p.Open_Date__c = System.today();
        p.Close_Date__c = System.today();
        insert p;
        
        ApplyController ac = new ApplyController();
        
        ac.resume = new Document();
        ac.resume.Body = Blob.valueOf('Test data');
        ac.resume.Name = 'resume';
        ac.parsedResume = new ParsedResume(ac.resume);
        ac.parsedResume.c = can;
        
        ac.uploadAction();           
    }
}