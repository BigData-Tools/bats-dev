public with sharing class Resume {
    //General Information
       private String firstName;
       private String lastName;
       private String email;
       private String phoneNumber;
       private Integer postalCode;
       private String countryCode;
       private String region;
       
    //Resume Specifics
        private String objective;
        private String executiveSummary;
    
    //Education
        private List<Education> educationHistory;
    
    //WorkHistory
        private List<WorkHistory> workHistory;
        
        private String sovrenResponse;
        
    public Resume(String sovrenResponse){
        if(sovrenResponse != null && sovrenResponse.length() > 0){
            this.sovrenResponse = sovrenResponse;
            List<String> informationRetrieveList = new List<String>();
            informationRetrieveList.add('GivenName');
            informationRetrieveList.add('FamilyName');
            informationRetrieveList.add('InternetEmailAddress');
            informationRetrieveList.add('FormattedNumber');
            informationRetrieveList.add('PostalCode');
            informationRetrieveList.add('CountryCode');
            informationRetrieveList.add('Region');
            informationRetrieveList.add('Objective');
            informationRetrieveList.add('ExecutiveSummary');
            parseGeneralInformation(informationRetrieveList);
            if(educationHistory == null){
                educationHistory = new List<Education>();
            }
            parseEducation();
        }else{
            workHistory = new List<workHistory>();
            educationHistory = new List<Education>();
            firstName = '';
        }
    }
        
     public void setFirstName(String firstName){
        this.firstName = firstName;
     }
     
     public void setLastName(String lastName){
        this.lastName = lastName;
     }
     
     public void setEmail(String email){
        this.email = email; 
     }
     
     public void setPhoneNumber (String phoneNumber){
        this.phoneNumber = phoneNumber;
     }
     
     public void setPostalCode(Integer postalCode){
        this.postalCode = postalCode;
     }
     
     public void setCountryCode(String countryCode){
        this.countryCode = countryCode; 
     }
     
     public void setRegion (String region){
        this.region = region;
     }
     
     public void setObjective (String objective){
        this.objective = objective;
     }
    
     public void setExecutiveSummary (String executiveSummary){
        this.executiveSummary = executiveSummary;
     }
     
     public void setEducationHistory (List<Education> educationHistory){
        this.educationHistory = educationHistory;
     }
     
     public void setWorkHistory (List<WorkHistory> workHistory){
        this.workHistory = workHistory;
     }
     
     
     
     public String getFirstName(){
        return firstName;
     }
     public String getLastName(){
        return lastName;
     }
     
     public String getEmail(){
        return email;
     }
     
     public String getPhoneNumber(){
        return phoneNumber;
     }
     
     public Integer getPostalCode(){
        return postalCode;
     }
     
     public String getCountryCode(){
        return countryCode;
     }
     
     public String getRegion(){
        return region;
     }
     
     public String getObjective(){
        return objective;
     }
     
     public String getExecutiveSummary(){
        return executiveSummary;
     }
     
     public List<Education> getEducationHistory(){
        return educationHistory;
     }
     
     public List<WorkHistory> getWorkHistory(){
        return workHistory;
     }
     
     
    private class ParsingResumeXMLResponseException extends Exception{}

    private void parseEducation(){
        if(sovrenResponse != null && sovrenResponse.length() > 0){
            XMLDom xmlDom = new XMLDom(sovrenResponse);
            List<XMLDom.Element> element = xmlDom.getElementsByTagName('SchoolOrInstitution');
            for(Integer i = 0; i < element.size(); i++){
                Education education = new Education();
                education.setDegreeName(xmlDom.getElementsByTagName('SchoolOrInstitution').get(i).getElementsByTagName('DegreeName').get(0).nodeValue);
                education.setInstituteName(xmlDom.getElementsByTagName('SchoolOrInstitution').get(i).getElementsByTagName('SchoolName').get(0).nodeValue);
                education.setDegreeType(xmlDom.getElementsByTagName('SchoolOrInstitution').get(i).getElementsByTagName('Degree').get(0).attributes.get('degreeType'));
                educationHistory.add(education);
            }
        } 
    }

    private void parseGeneralInformation(List<String> informationRetrieveList){
        if(sovrenResponse != null && sovrenResponse.length() > 0 && informationRetrieveList != null && informationRetrieveList.size() > 0){
            XMLDom xmlDom = new XMLDom(sovrenResponse);
            Map<String, String> informationMap = new Map<String, String>();
            for(String informationNodeName : informationRetrieveList){
                List<XMLDom.Element> element = xmlDom.getElementsByTagName(informationNodeName);
                if(element != null && element.size() > 0){
                    informationMap.put(informationNodeName, xmlDom.getElementsByTagName(informationNodeName).get(0).nodeValue);
                }else{}
            }
            firstName = informationMap.get('GivenName');
            lastName = informationMap.get('FamilyName');
            email = informationMap.get('InternetEmailAddress');
            phoneNumber = informationMap.get('FormattedNumber');
            postalCode = Integer.valueOf(informationMap.get('PostalCode'));
            countryCode = informationMap.get('CountryCode');
            region = informationMap.get('Region');
            objective = informationMap.get('Objective');
            executiveSummary = informationMap.get('ExecutiveSummary');
        }
    }     
}