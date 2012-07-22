public with sharing class AAResume {
    
    private AAGeneralInformation generalInformation;
    private AAPreScreening preScreening;
    private List<AAEducation> educationList;
    private List<AAWork> workList;
    private List<AAAward> awardList;
    private List<AACertification> certificationList;
    private List<AAReference> referenceList;
    
    private String sovrenResponse;
        
    public AAResume(String sovrenResponse){
        generalInformation = new AAGeneralInformation();
        preScreening = new AAPreScreening();
        
        //Since they have parsing method then will willn't add items unless the list size after parsing is still zero
        educationList = new List<AAEducation>();
        workList = new List<AAWork>();
        
        //Single Item is added in order to allow the user to see at least single inputplace holder for each object of those lists
        awardList = new List<AAAward>();
        awardList.add(new AAAward());
        
        certificationList = new List<AACertification>();
        certificationList.add(new AACertification());
        
        referenceList = new List<AAReference>();
        referenceList.add(new AAReference());
        
        if(sovrenResponse != null && sovrenResponse.length() > 0){
            this.sovrenResponse = sovrenResponse;
            generalInformation = new AAGeneralInformation();
            parseGeneralInformation();
            parseEducation();
            parseWorkHistory();
        }
        
        if(educationList.size() < 1){
            educationList.add(new AAEducation());
        }
        
        if(workList.size() < 1){
            workList.add(new AAWork());
        }
    }
    
    
    public void setPreScreening (AAPreScreening preScreening){
        this.preScreening = preScreening;
    }
    
    public void setAwardList(List<AAAward> awardList){
        this.awardList = awardList;
    }
    
    public void setCertificationList(List<AACertification> certificationsList){
        this.certificationList = certificationList;
    }
    
    public void setReferenceList(List<AAReference> referenceList){
        this.referenceList = referenceList;
    }
     
     public void setGeneralInformation(AAGeneralInformation generalInformation){
         this.generalInformation = generalInformation;
     }
     
     public AAGeneralInformation getGeneralInformation(){
         return generalInformation;
     }
     
     public void setEducationList (List<AAEducation> educationList){
        this.educationList = educationList;
     }
     
     public void setWorkList (List<AAWork> workList){
        this.workList = workList;
     }
     
     public AAPreScreening getPreScreening(){
         return preScreening;
     }
     
     public List<AAEducation> getEducationList(){
        return educationList;
     }
     
     public List<AAWork> getWorkList(){
        return workList;
     }
     
    public List<AAAward> getAwardList(){
        return awardList;
    }
    
    public  List<AACertification> getCertificationList(){
        return certificationList;
    }
    
    public  List<AAReference> getReferenceList(){
        return referenceList;
    }
     
     
    private class ParsingResumeXMLResponseException extends Exception{}

    private void parseEducation(){
        if(sovrenResponse != null && sovrenResponse.length() > 0){
            XMLDom xmlDom = new XMLDom(sovrenResponse);
            List<XMLDom.Element> element = xmlDom.getElementsByTagName('SchoolOrInstitution');
            for(Integer i = 0; i < element.size(); i++){
                AAEducation education = new AAEducation();
                education.setDegreeName(xmlDom.getElementsByTagName('SchoolOrInstitution').get(i).getElementsByTagName('DegreeName').get(0).nodeValue);
                education.setInstituteName(xmlDom.getElementsByTagName('SchoolOrInstitution').get(i).getElementsByTagName('SchoolName').get(0).nodeValue);
                education.setDegreeType(xmlDom.getElementsByTagName('SchoolOrInstitution').get(i).getElementsByTagName('Degree').get(0).attributes.get('degreeType'));
                educationList.add(education);
            }
        } 
    }
    
    private void parseWorkHistory(){
        if(sovrenResponse != null && sovrenResponse.length() > 0){
            XMLDom xmlDom = new XMLDom(sovrenResponse);
            List<XMLDom.Element> element = xmlDom.getElementsByTagName('EmployerOrg');
            for(Integer i = 0; i < element.size(); i++){
                AAWork work = new AAWork();
                work.setCompanyName(xmlDom.getElementsByTagName('EmployerOrg').get(i).getElementsByTagName('EmployerOrgName').get(0).nodeValue);
                work.setJobTitle(xmlDom.getElementsByTagName('EmployerOrg').get(i).getElementsByTagName('Title').get(0).nodeValue);
                //education.setDegreeType(xmlDom.getElementsByTagName('EmployerOrg').get(i).getElementsByTagName('Degree').get(0).attributes.get('degreeType'));
                workList.add(work);
            }
        } 
    }

    
    private void parseGeneralInformation(){
        if(sovrenResponse != null && sovrenResponse.length() > 0){
            XMLDom xmlDom = new XMLDom(sovrenResponse);
            List<XMLDom.Element> temp = xmlDom.getElementsByTagName('GivenName');
            if(temp != null && temp.size() > 0){
                generalInformation.setFirstName(xmlDom.getElementsByTagName('GivenName').get(0).nodeValue);
            }
            
            temp = xmlDom.getElementsByTagName('FamilyName');
            if(temp != null && temp.size() > 0){
                generalInformation.setLastName(xmlDom.getElementsByTagName('FamilyName').get(0).nodeValue);
            }
            
            temp = xmlDom.getElementsByTagName('InternetEmailAddress');
            if(temp != null && temp.size() > 0){
                generalInformation.setEmail(xmlDom.getElementsByTagName('InternetEmailAddress').get(0).nodeValue);
            }
            
            temp = xmlDom.getElementsByTagName('FormattedNumber');
            if(temp != null && temp.size() > 0){
                generalInformation.setPhoneNumber(xmlDom.getElementsByTagName('FormattedNumber').get(0).nodeValue);
            }
          
            temp = xmlDom.getElementsByTagName('CountryCode');
            if(temp != null && temp.size() > 0){
                generalInformation.setCountry(xmlDom.getElementsByTagName('CountryCode').get(0).nodeValue);
            }
            
            temp = xmlDom.getElementsByTagName('Objective');
            if(temp != null && temp.size() > 0){
                generalInformation.setObjective(xmlDom.getElementsByTagName('Objective').get(0).nodeValue);
            }
            
            temp = xmlDom.getElementsByTagName('ExecutiveSummary');
            if(temp != null && temp.size() > 0){
                generalInformation.setExecutiveSummary(xmlDom.getElementsByTagName('ExecutiveSummary').get(0).nodeValue);
            }
        }
    }
    
    //New Code-------------------------------------------------------------
     public AAResume(Candidate__c candidate, Application__c application, String sovrenResponse){
         if(candidate != null && application != null){
             if(sovrenResponse == null){
                 return;
             }else{
                 this.sovrenResponse = sovrenResponse;
                 parseGeneralInformation(candidate);
             }
         }else{
             throw new NullPointerException();
         }
     }
     
     private void parseGeneralInformation(Candidate__c candidate){
        if(sovrenResponse != null && sovrenResponse.length() > 0){
            XMLDom xmlDom = new XMLDom(sovrenResponse);
            List<XMLDom.Element> temp = xmlDom.getElementsByTagName('GivenName');
            if(temp != null && temp.size() > 0){
               candidate.First_Name__c = xmlDom.getElementsByTagName('GivenName').get(0).nodeValue;
            }
            
            temp = xmlDom.getElementsByTagName('FamilyName');
            if(temp != null && temp.size() > 0){
                candidate.Last_Name__c = xmlDom.getElementsByTagName('FamilyName').get(0).nodeValue;
            }
            
            temp = xmlDom.getElementsByTagName('InternetEmailAddress');
            if(temp != null && temp.size() > 0){
                candidate.Email__c = xmlDom.getElementsByTagName('InternetEmailAddress').get(0).nodeValue;
            }
            
            temp = xmlDom.getElementsByTagName('FormattedNumber');
            if(temp != null && temp.size() > 0){
                candidate.Phone__c = xmlDom.getElementsByTagName('FormattedNumber').get(0).nodeValue;
            }
        }
    }
     
     /*private void parseEducation(Candidate__c candidate){
        if(sovrenResponse != null && sovrenResponse.length() > 0){
            XMLDom xmlDom = new XMLDom(sovrenResponse);
            List<XMLDom.Element> element = xmlDom.getElementsByTagName('SchoolOrInstitution');
            if(xmlDom.getElementsByTagName('SchoolOrInstitution')!= null && xmlDom.getElementsByTagName('SchoolOrInstitution').size() > 0 && xmlDom.getElementsByTagName('SchoolOrInstitution').get(0).getElementsByTagName('SchoolName') != null && xmlDom.getElementsByTagName('SchoolOrInstitution').size() > 0)
            for(Integer i = 0; i < element.size(); i++){
                //education.setDegreeName(xmlDom.getElementsByTagName('SchoolOrInstitution').get(i).getElementsByTagName('DegreeName').get(0).nodeValue);
                candidate.University__c = xmlDom.getElementsByTagName('SchoolOrInstitution').get(i).getElementsByTagName('SchoolName').get(0).nodeValue);
                //education.setDegreeType(xmlDom.getElementsByTagName('SchoolOrInstitution').get(i).getElementsByTagName('Degree').get(0).attributes.get('degreeType'));
                //educationList.add(education);
            }
        } 
    }*/ 
     
}