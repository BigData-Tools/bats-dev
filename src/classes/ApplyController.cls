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
        //TODO - implement this part/call function to do it.
        
        //create Candidate
        Candidate__c c = new Candidate__c();
        c.First_Name__c = parsedResume.GivenName;
        c.Last_Name__c = parsedResume.FamilyName;
        c.Phone__c = parsedResume.Phone;
        c.Email__c = parsedResume.Email;
        c.Skype_Username__c = parsedResume.Skype;
        
        c.Street__c = parsedResume.Street;
        c.City__c = parsedResume.City;
        c.State__c = parsedResume.State;
        c.Zip_Code__c = parsedResume.Zip;
        c.Skype_Username__c = parsedResume.Skype;
        
        c.University__c = parsedResume.SchoolName;
        
        c.Current_Employer__c = parsedResume.EmployerOrgName;
        c.Current_Title__c = parsedResume.Title;
        insert c;
        
        //create Application
        //TODO - implement this part.
        
        return new PageReference('/apex/ApplyComplete');
    }
}