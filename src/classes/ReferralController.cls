global with sharing class ReferralController {

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
    
     public Position__c position{
        public get;
        public set;
    }
    
    public String notes{
        get;
        set;
    }
    
    public ReferralController(){
        candidate = new Candidate__c();
        agent = new Agent__c(); 
        position = new Position__c();   
    }
    
    private List<ApexPages.Message> validation(){
        List<ApexPages.Message> errorMessageList = new List<ApexPages.Message>();
        try{
            if(resume != null && resume.name != null && !(resume.name.contains('.doc') || resume.name.contains('.docx') || resume.name.contains('.pdf'))){
                errorMessageList.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'invalid file type'));
            }

           if(candidate.Referrer_Email__c != null && !candidate.Referrer_Email__c.contains('box.com')){
               errorMessageList.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'invalid email address for box employee, please use your @box.com email'));
           }
              
           if(resume != null && resume.name == null && (candidate.LinkedIn_Profile_URL__c == null || candidate.LinkedIn_Profile_URL__c.length() < 1)){
               errorMessageList.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'you need either Resume document or LinkedIn Profile'));
           }
           
           if(candidate.LinkedIn_Profile_URL__c != null && candidate.LinkedIn_Profile_URL__c.length() > 0 && candidate.LinkedIn_Profile_URL__c.toLowerCase().contains('linkedin.com') == false){
               errorMessageList.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'invalid LinkedIn Profile URL'));
           }
           
           if(position.Name != null && position.Name.length() > 0 && position.Name.toLowerCase().equals('none')){
               errorMessageList.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Position'));
           }

           if(candidate.Street__c == null || candidate.Street__c.length() < 1){
               candidate.Street__c = 'Anywhere';
           }

        }catch(Exception e){
            errorMessageList.add(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return errorMessageList;
    }
    
    //for debug only
    public String responseBody{get; private set;}
    
    public ParsedResume parsedResume{get; private set;}
    
    private PageReference referAction(boolean employee){
        List<ApexPages.Message> errorsList = validation();
        if(errorsList.size() < 1){
            try{
                Application__c application = new Application__c();
                if(resume != null && resume.name != null){
                    BoxUpload boxUpload = new BoxUpload(resume);
                    responseBody = boxUpload.getUploadedFileId();
                    application.Box_Resume_Id__c = boxUpload.getUploadedFileId();
                    application.Box_Resume_Link__c = 'https://www.box.com/shared/' + boxUpload.getUploadedFileShareLink();
                }
                
                if(employee){
                    candidate.Source__c = 'Employee Referreral';
                }else{
                    candidate.Source__c = 'Agent ' + Agent.Name;
                }
                insert candidate;
                
                
                application.candidate_email_address__c = candidate.Email__c;
                application.Position__c  = [select id from position__c where name =:position.Name].get(0).id;
                if(employee){
                    application.source__c = 'Employee Referral';
                }else{
                    application.source__c = Agent.Name + ' Referral';
                }
                application.status__c = 'New';
                application.candidate__c = [select id from candidate__c where Email__c =: candidate.Email__c].get(0).id;
                if(notes != null){
                    application.Notes__c = notes;
                }else{
                    application.Notes__c = '';
                }
                insert application;
            }catch(Exception e){
                ApexPages.Message catchErrorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
                ApexPages.addMessage(catchErrorMessage); 
                return null;
            }
            return new PageReference('/apex/ApplyComplete');
            
        }else{
            for(ApexPages.Message errorMessage : errorsList){
                ApexPages.addMessage(errorMessage);
            } 
            return null;
        } 
    }
    
    public PageReference employeeReferreralAction(){
        try{
            return referAction(true);
        }catch(Exception e){
            return null;
        }
    }
    
    public PageReference agentReferralAction(){
        try{
            return referAction(false);
        }catch(Exception e){
            return null;
        }
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
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'unauthorized agent')); 
            }
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Agent credentials')); 
        }
        return null;
    }
    
    public List<selectOption> departmentsList {
    public get {
        Set<String> tempDepartmentsList = new Set<String>();
        //List<selectOption> departmentsList = new List<selectOption>();
            for (position__c department : [select department__c from position__c]){
                tempDepartmentsList.add(department.department__c);
            }
            
            List<selectOption> departmentsList = new List<selectOption>();
            for(String departmentName : tempDepartmentsList){
                departmentsList.add(new selectOption(departmentName, departmentName));
            }
            return departmentsList;
        }
        private set;
    }
    
    public List<selectOption> positionsList{
        public get{
            List<selectOption> positionsList = new List<selectOption>();
            try{        
                 for(Position__c positionItem : [select Name from Position__c]){
                        positionsList.add(new selectOption(positionItem.Name, positionItem.Name));
                 }
            }catch(Exception e){
                 positionsList.add(new selectOption('None', 'None'));
            }
            return positionsList;
        }
        
        public set;
    }
    
    @RemoteAction
    global static String getPositionListDynamically(String departmentName){
        String result = '';
        try{
            for (Position__c positionItem : [select Name from Position__c where Department__c = :departmentName]){
                    result += positionItem.Name + ',';
            }
        }catch(Exception e){
            result = 'None,';
        }
        return result;
    }
    
   
    
     /*------------ Tests only below this line ------------*/
    static testMethod void testApplyAgentController(){
        
        //first run all methods with no mock objects
        ReferralController rc0 = new ReferralController();
        rc0.validation();
        rc0.employeeReferreralAction();
        rc0.agentReferralAction();
        rc0.verifyAgentAction();
        ReferralController.getPositionListDynamically('');
        
        //now run them with mock objects
        ReferralController rc = new ReferralController();
        rc.resume = new Document();
        rc.resume.Body = Blob.valueOf('Test data');
        rc.resume.Name = 'resume.doc';        
        
        Candidate__c c = new Candidate__c();      
        c.First_Name__c = 'user';
        c.Last_Name__c = 'user';
        c.Email__c = 'user@box.com';
        rc.candidate = c;
        
        Position__c p = new Position__c();
        p.Department__c = 'Engineering';
        p.Name = 'positionName';
        p.Number_of_Hires__c = 5;
        User u = [SELECT Id FROM User].get(0);
        p.Hiring_Manager__c = u.Id;
        p.Recruiter__c = u.Id; 
        p.Coordinator__c = u.Id; 
        p.Open_Date__c = System.today();
        p.Close_Date__c = System.today();
        rc.position = p;
        
        rc.employeeReferreralAction();
        rc.agentReferralAction();
    }
}