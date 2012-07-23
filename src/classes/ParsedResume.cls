public with sharing class ParsedResume {

    public String resumeText{get; set;}
    private String resumeXML;
    private sovrenCom.ConvertAndParseSoap sovren;

    /* Given a resume Document, uses Sovren to parse the document, and
     * stores the raw text in resumeText, and stores the HR-XML in resumeXML
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
        GivenName = getFirstField('GivenName');
        FamilyName = getFirstField('FamilyName');
        Phone = getFirstField('FormattedNumber');
        Email = getFirstField('InternetEmailAddress');
        
        Street = getFirstField('AddressLine');
        City = getFirstField('Municipality');
        State = getFirstField('Region');
        Zip = getFirstField('PostalCode');
        Country = getFirstField('CountryCode');
        
        SchoolName = getFirstField('SchoolName');
        
        EmployerOrgName = getFirstField('EmployerOrgName');
        Title = getFirstField('Title');        
    }
        
    //Information we will parse & store from the resume
    public String GivenName{get; set;}
    public String FamilyName{get; set;}
    public String Phone{get; set;}
    public String Email{get; set;}
    public String Skype{get; set;}
    
    public String Street{get; set;}
    public String City{get; set;}
    public String State{get; set;}
    public String Zip{get; set;}
    public String Country{get; set;}
    
    public String SchoolName{get; set;}
    
    public String EmployerOrgName{get; set;}
    public String Title{get; set;}
    
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