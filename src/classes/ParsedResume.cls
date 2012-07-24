public with sharing class ParsedResume {

    /*resumeText: is string which contains the text of the resume
    */
    public String resumeText{get; set;}
    
    /*resumeXML: is string which contains the parsed resume of the text.
      it differs from the resume text that contains the resume as parsed xml version
      rather than plain resume text
    */
    private String resumeXML;
    
    /** Candidate: is customized Object that corresponds to Job Applicant
    */
    public Candidate__c c{get; set;}
    
    /**
        sovren: which contains all sovren methods to parse and convert resumes
    */
    private sovrenCom.ConvertAndParseSoap sovren;

    /* Given a resume Document, uses Sovren to parse the document, and
     * stores the raw text in resumeText, and stores the HR-XML in resumeXML
     
         resumeDoc: is object which will contains the resume binaries and 
         pass it to sovren webservice
     */
    public ParsedResume(Document resumeDoc) {
        sovren = new sovrenCom.ConvertAndParseSoap();        
        if (resumeDoc != null) {
            resumeText = sovren.DoConversionSimplified(EncodingUtil.Base64Encode(resumeDoc.body),'PLAIN_TEXT');            
        }
    }
    
    /* Sends the resume text to Sovren to be parsed. Stores the HR-XML result in resumeXML. 
     */
    public void parseToXML() {
        resumeXML = sovren.ParseConvertedResume(resumeText , false, false, 5000, 2,'1', false,'1');
        c = new Candidate__c();

        c.First_Name__c = getFirstField('GivenName');
        c.Last_Name__c = getFirstField('FamilyName');
        c.Phone__c = getFirstField('FormattedNumber');
        c.Email__c = getFirstField('InternetEmailAddress');
        
        c.Street__c = getFirstField('AddressLine');
        c.City__c = getFirstField('Municipality');
        c.State__c = getFirstField('Region');
        c.Zip_Code__c = getFirstField('PostalCode');
        
        c.University__c = getFirstField('SchoolName');
        
        c.Current_Employer__c = getFirstField('EmployerOrgName');
        c.Current_Title__c = getFirstField('Title');        
    }
    
    /* Helper method to populate variables
     * Returns the contents of the first XML element identified by fieldName 
     */
    private String getFirstField(String fieldName) {
        XMLDom xmlDom = new XMLDom(resumeXML);
        try {
            return xmlDom.getElementsByTagName(fieldName).get(0).nodeValue;
        } catch (System.ListException e) {
            return '';
        }
    }
}