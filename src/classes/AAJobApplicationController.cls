public class AAJobApplicationController{

    private Integer workListLimit = 4;
    private Integer educationListLimit = 4;
    private Integer awardListLimit = 2;
    private Integer certificationListLimit = 5;
    private Integer referenceListLimit = 3;
    private String [] JobApplicationFlowPages = new String[] {'AAUpload', 'AAResumeText',  'AAGeneralInformation', 'AAWork', 'AAEducation', 'AACertification', 'AAReference', 'AAPreScreening', 'AAReviewApplication', 'AASubmitJobApplicationSuccessfully'};

    public Document document{
        get{
            if(document == null){
                document = new Document();
            }
            return document;
        }
        set;
    }
    
    public String resumeText{
        get;
        set;
    }
    
    public AAResume resume{
        get;
        set;
    }
    
    public String fileResponse{
        get;
        set;
    }

    public AAJobApplicationController(){
        if(candidate == null){
            candidate = new Candidate__c();
        }
        
        if(application == null){
            application = new Application__c();
        }
    }    
    
    public void addEducationListItem(){
        if(resume != null && resume.getEducationList() != null && resume.getEducationList().size() <= educationListLimit){
            List<AAEducation> educationList = resume.getEducationList();
            educationList.add(new AAEducation());
            resume.setEducationList(educationList);
        }
    }
    
    public void addWorkListItem(){
        if(resume != null && resume.getWorkList() != null && resume.getWorkList().size() <= workListLimit){
            List<AAWork> workList = resume.getWorkList();
            workList.add(new AAWork());
            resume.setWorkList(workList);
        }
    }
    
    public void addCertificationListItem(){
        if(resume != null && resume.getCertificationList() != null && resume.getCertificationList().size() <= certificationListLimit){
            List<AACertification> certificationList = resume.getCertificationList();
            certificationList.add(new AACertification());
            resume.setCertificationList(certificationList);
        }
    }
    
    public void addAwardListItem(){
        if(resume != null && resume.getAwardList() != null && resume.getAwardList().size() <= awardListLimit){
            List<AAAward> awardList = resume.getAwardList();
            awardList.add(new AAAward());
            resume.setAwardList(awardList);
        }
    }
    
    public void addReferenceListItem(){
        if(resume != null && resume.getReferenceList() != null && resume.getReferenceList().size() <= referenceListLimit){
            List<AAReference> referenceList = resume.getReferenceList();
            referenceList.add(new AAReference());
            resume.setReferenceList(referenceList);
        }
    }
    
    
    public void removeEducationListItem(){
        if(resume != null && resume.getEducationList() != null && resume.getEducationList().size() > 1){
            List<AAEducation> educationList = resume.getEducationList();
            educationList.remove(educationList.size() - 1);
            resume.setEducationList(educationList);
        }
    }
    
    public void removeWorkListItem(){
        if(resume != null && resume.getWorkList() != null && resume.getWorkList().size() > 1){
            List<AAWork> workList = resume.getWorkList();
            workList.remove(workList.size() - 1);
            resume.setWorkList(workList);
        }
    }
    
    public void removeAwardListItem(){
        if(resume != null && resume.getAwardList() != null && resume.getAwardList().size() > 1){
            List<AAAward> awardList = resume.getAwardList();
            awardList.remove(awardList.size() - 1);
            resume.setAwardList(awardList);
        }
    }
    
    public void removeCertificationListItem(){
        if(resume != null && resume.getCertificationList() != null && resume.getCertificationList().size() > 1){
            List<AACertification> certificationList = resume.getCertificationList();
            certificationList.remove(certificationList.size() - 1);
            resume.setCertificationList(certificationList);
        }
    }
    
    public void removeReferenceListItem(){
        if(resume != null && resume.getReferenceList() != null && resume.getReferenceList().size() > 1){
            List<AAReference> referenceList = resume.getReferenceList();
            referenceList.remove(referenceList.size() - 1);
            resume.setReferenceList(referenceList);
        }
    }
    
    
    public pageReference textResumeAction(){
        PageReference Page;
        Integer currentPageSequenceNumber = 1;
        page = new PageReference('/apex/' + JobApplicationFlowPages[currentPageSequenceNumber + 1]);
        sovrenCom.ConvertAndParseSoap obj = new sovrenCom.ConvertAndParseSoap();
        String sovrenXML = obj.ParseConvertedResume(resumeText , false, false, 5000, 2,'1', false,'1');
        if(resume == null){
            resume = new AAResume(sovrenXML);
        }else{
            System.debug('Was initiated before');
        }
        return page;
    }
    
    public pageReference generalInformationAction(){
        PageReference Page;
        Integer currentPageSequenceNumber = 2;
        page = new PageReference('/apex/' + JobApplicationFlowPages[currentPageSequenceNumber + 1]);
        return page;
    }
    
    public pageReference workAction(){
        PageReference Page;
        Integer currentPageSequenceNumber = 3;
        page = new PageReference('/apex/' + JobApplicationFlowPages[currentPageSequenceNumber + 1]);
        return page;
    }
    
    public pageReference educationAction(){
        PageReference Page;
        Integer currentPageSequenceNumber = 4;
        page = new PageReference('/apex/' + JobApplicationFlowPages[currentPageSequenceNumber + 1]);
        return page;
    }
    
     public pageReference awardCertificationAction(){
        PageReference Page;
        Integer currentPageSequenceNumber = 5;
        page = new PageReference('/apex/' + JobApplicationFlowPages[currentPageSequenceNumber + 1]);
        return page;
    }
    
    public pageReference referenceAction(){
        PageReference Page;
        Integer currentPageSequenceNumber = 6;
        page = new PageReference('/apex/' + JobApplicationFlowPages[currentPageSequenceNumber + 1]);
        return page;
    }
    
     public pageReference preScreeningAction(){
        PageReference Page;
        Integer currentPageSequenceNumber = 7;
        page = new PageReference('/apex/' + JobApplicationFlowPages[currentPageSequenceNumber + 1]);
        return page;
    }
    
    public pageReference convertToText(){
        PageReference page = new PageReference('/apex/TextResume');
        sovrenCom.ConvertAndParseSoap obj = new sovrenCom.ConvertAndParseSoap();
        String sovrenResponse = '';
        if(document.body.size() > 0){
            resumeText = obj.DoConversionSimplified(EncodingUtil.Base64Encode(document.body),'PLAIN_TEXT');
        }else{
            page = new PageReference('/apex/Exception');  
        }
        return page;  
    }
    
    public pageReference parseResume(){
        PageReference page = new PageReference('/apex/ApplicationForm');
        sovrenCom.ConvertAndParseSoap obj = new sovrenCom.ConvertAndParseSoap();
        String sovrenXML = obj.ParseConvertedResume(resumeText , false, false, 5000, 2,'1', false,'1');
        if(resume == null){
            resume = new AAResume(sovrenXML);
        }else{
            System.debug('Was initiated before');
        }
        return page;
    }
    
    public PageReference saveDocument(){
        PageReference page = new PageReference('/apex/ApplicationForm');       
        page.setRedirect(true);
        return page;   
     }
    
    public pageReference uploadAction(){
        PageReference page = new PageReference('/apex/' + JobApplicationFlowPages[1]);
        sovrenCom.ConvertAndParseSoap obj = new sovrenCom.ConvertAndParseSoap();
        String sovrenResponse = '';
        if(document != null && document.body != null && document.body.size() > 0){
            resumeText = obj.DoConversionSimplified(EncodingUtil.Base64Encode(document.body),'PLAIN_TEXT');
        }else{
            resumeText = 'No File Was Found';
        }
        return page;
    }
    
    public class FileNotFoundException extends Exception{}
    
    public pageReference reviewAction(){
        PageReference Page;
        Integer currentPageSequenceNumber = 8;
        page = new PageReference('/apex/' + JobApplicationFlowPages[currentPageSequenceNumber + 1]);
        if(document != null){
            AAUploadHelper uploader = new AAUploadHelper();
            fileResponse = uploader.uploadToBox('https://api.box.com/2.0/files/data', document).getBody();
        }else{
            throw new FileNotFoundException();
        }
        return page;
    }
    
    //New Code------------------------------------------------------------------------------------
    
    private String [] PagesNameArray = new String [] {'AAUpload', 'AAResumeText', 'AASubmitApp', 'AASubmitJobApplicationSuccessfully'};
    
    public Candidate__c candidate{
        get;
        set;
    }
    
    public Application__c application{
        get;
        set;
    }
    
    public String testString{
        get;
        set;
    }
    
    public pageReference aaUploadAction2(){
        PageReference Page;
        Integer currentPageSequenceNumber = 0;
        page = new PageReference('/apex/' + PagesNameArray[currentPageSequenceNumber + 1]);
        sovrenCom.ConvertAndParseSoap obj = new sovrenCom.ConvertAndParseSoap();
        String sovrenResponse = '';
        if(document != null && document.body != null && document.body.size() > 0){
            resumeText = obj.DoConversionSimplified(EncodingUtil.Base64Encode(document.body),'PLAIN_TEXT');
        }
        return page;
    }
    
    public pageReference aaResumeText2(){
        PageReference Page;
        Integer currentPageSequenceNumber = 1;
        page = new PageReference('/apex/' + PagesNameArray[currentPageSequenceNumber + 1]);
        sovrenCom.ConvertAndParseSoap obj = new sovrenCom.ConvertAndParseSoap();
        String sovrenXML = obj.ParseConvertedResume(resumeText , false, false, 5000, 2,'1', false,'1');
        testString = sovrenXML;
        if(resume == null){
            //resume = new AAResume(candidate, application, sovrenXML);
            resume = new AAResume(sovrenXML);
            convertObjects();
        }
        return page;
    }
    
    private void convertObjects(){
         candidate.First_Name__c = resume.getGeneralInformation().getFirstName();
         candidate.Last_Name__c = resume.getGeneralInformation().getLastName();
         candidate.Email__c = resume.getGeneralInformation().getEmail();
         candidate.Phone__c = resume.getGeneralInformation().getPhoneNumber();
    }
    
    public pageReference aaSubmitApp2(){
        //the save method
        PageReference Page;
        Integer currentPageSequenceNumber = 2;
        page = new PageReference('/apex/' + PagesNameArray[currentPageSequenceNumber + 1]);
        return page;
    }
    
    public List<selectOption> getDegreeTypeList() {
        List<selectOption> options = new List<selectOption>(); 
        options.add(new selectOption('', '- None -'));
        for (Candidate__c can : [SELECT Education__c FROM Candidate__c]) { 
            options.add(new selectOption(can.Education__c, can.Education__c));
        }
        return options;
    }
    
}