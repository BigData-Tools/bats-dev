public with sharing class ReferralController {

    public Document resume{
        get{
            if(resume == null){
                resume = new Document();
            }
            return resume;
        }
        set;
    }
    
    public Agent__c agent{
        public get;
        public set;
    }
    
    public Candidate__c candidate{
        public get;
        public set;
    }
    
    public ReferralController(){
        candidate = new Candidate__c();
        agent = new Agent__c(); 
        position = new Position__c();   
    }
    
    private boolean validation(){
        try{
            ApexPages.Message errorMessage;
            
            if(resume != null && resume.name != null && !(resume.name.contains('.doc') || resume.name.contains('.docx') || resume.name.contains('.pdf'))){
                errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'invalid file type');
                ApexPages.addMessage(errorMessage); 
                return null;
            }

           if(candidate.Referrer_Email__c != null && !candidate.Referrer_Email__c.contains('box.com')){
               errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'invalid email address for box employee, please use your @box.com email');
               ApexPages.addMessage(errorMessage); 
               return null;
           }
              
           if(resume == null && (candidate.LinkedIn_Profile_URL__c == null || candidate.LinkedIn_Profile_URL__c.length() < 1)){
               errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'you need either Resume document or LinkedIn Profile');
               ApexPages.addMessage(errorMessage); 
               return null;
           }
           
           if(candidate.LinkedIn_Profile_URL__c != null && candidate.LinkedIn_Profile_URL__c.length() > 0 && candidate.LinkedIn_Profile_URL__c.contains('LinkedIn.com') == false){
               errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'valid LinkedIn Profile URL');
               ApexPages.addMessage(errorMessage); 
               return null;
           }

           if(candidate.Street__c == null || candidate.Street__c.length() < 1){
               //since this is required in the candidate object but the employee may/maynot know it therefore I am setting default value if it has no value
               candidate.Street__c = 'Anywhere';
           }

        }catch(Exception e){
            ApexPages.Message catchErrorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(catchErrorMessage); 
            return null;
        }
        return true;
    }
    
    //for debug only
    public String responseBody{get; private set;}
    
    public ParsedResume parsedResume{get; private set;}
    
    public PageReference employeeReferreralAction(){
        if(validation() != null){
            try{
                if(resume != null && resume.name != null){
                    BoxUpload boxUpload = new BoxUpload(resume);
                    responseBody = boxUpload.getUploadedFileId();
                }
                candidate.Source__c = 'Employee Referreral';
                insert candidate;
            }catch(Exception e){
                ApexPages.Message catchErrorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
                ApexPages.addMessage(catchErrorMessage); 
                return null;
            }
            return new PageReference('/apex/ApplyComplete');
        }
        return null;
    }
    
    public PageReference agentReferralAction(){
        if(validation() != null){
            try{
                if(resume != null && resume.name != null){
                    BoxUpload boxUpload = new BoxUpload(resume);
                    responseBody = boxUpload.getUploadedFileId();
                }
                candidate.Source__c = 'Agent ' + Agent.Name;
                insert candidate;
            }catch(Exception e){
                ApexPages.Message catchErrorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
                ApexPages.addMessage(catchErrorMessage); 
                return null;
            }
            return new PageReference('/apex/ApplyComplete');
        }
        return null;
    }
    
    //delete me after test
    public String message{
        public get;
        public set;
    }
    
    public PageReference verifyAgentAction(){
        try{
            Agent__c selectedAgent = [select Name, url__c from Agent__c where url__c = :agent.url__c and Name =:Agent.Name];
            if(selectedAgent != null){
                return new PageReference('/apex/AgentReferral'); 
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'it is not listed there')); 
            }
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Agent credentials')); 
        }
        return null;
    }
    
    public List<selectOption> departmentsList {
    public get {
        List<selectOption> departmentsList = new List<selectOption>();
            for (position__c department : [select department__c from position__c]){
                departmentsList.add(new selectOption(department.department__c, department.department__c));
            }
            return departmentsList;
        }
        private set;
    }
    
    public List<selectOption> positionsList{
        public get{
            List<selectOption> positionsList = new List<selectOption>();
            for (Position__c positionItem : [select Name from Position__c]){
                positionsList.add(new selectOption(positionItem.Name, positionItem.Name));
            }
            positionsList.add(new selectOption('null', 'null'));
            return positionsList;
        }
        
        public set;
    }
    
    public List<selectOption> testPositionsList{
        public get{
            List<selectOption> positionsList = new List<selectOption>();
            for (Position__c positionItem : [select Name from Position__c where Department__c = 'Engineering']){
                positionsList.add(new selectOption(positionItem.Name, positionItem.Name));
            }
            return positionsList;
        }
        
        public set;
    }
    
    public String getPositionListDynamically(String departmentName){
        return 'From Dynamic Method: ' + departmentName;
    }
    
    public Position__c position{
        public get;
        public set;
    }
    
     /*------------ Tests only below this line ------------*/
    static testMethod void testApplyAgentController(){
        ReferralController ttt = new ReferralController();
        ttt.validation();
        ttt.employeeReferreralAction();
    
    }
}