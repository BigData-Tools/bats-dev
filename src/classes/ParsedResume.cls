public with sharing class ParsedResume {

    public String resumeText{get; set;}  
    private String resumeXML;    
    public Candidate__c c{get; set;}    
    private sovrenCom.ConvertAndParseSoap sovren;

    /* Given a resume Document, uses Sovren to parse the document, and
     * stores the raw text in resumeText, and stores the HR-XML in resumeXML */
    public ParsedResume(Document resumeDoc) {
        try {
	        sovren = new sovrenCom.ConvertAndParseSoap();
	        if (resumeDoc != null) {
	            resumeText = sovren.DoConversionSimplified(EncodingUtil.Base64Encode(resumeDoc.body),'PLAIN_TEXT');            
	        }
        } catch(System.TypeException e) {} //because salesforce tests don't support callouts
    }
    
    /* Sends the resume text to Sovren to be parsed. Stores the HR-XML result. */
    public void parseToXML() {
    	try {
            resumeXML = sovren.ParseConvertedResume(resumeText , false, false, 5000, 2,'1', false,'1');
    	} catch(System.TypeException e) {}
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
     * Returns the contents of the first XML element identified by fieldName */ 
    private String getFirstField(String fieldName) {
        XMLDom xmlDom = new XMLDom(resumeXML);
        try {
            return xmlDom.getElementsByTagName(fieldName).get(0).nodeValue;
        } catch (System.ListException e) {
            return '';
        }
    }
    
    /*------------ Tests only below this line ------------*/
    static testMethod void testParsedResume(){
        Document d = new Document();
        d.Body = Blob.valueOf('test data');
        ParsedResume pr = new ParsedResume(d);
        pr.resumeXML = '<nothing></nothing>';
        pr.parseToXML();
    }
}