public with sharing class ParsedResume {

    private String resumeText;
    private String resumeXML;

    /* Given a resume Document, uses Sovren to parse the document, and
     * stores the raw text in resumeText, and stores the HR-XML in resumeXML
     */
    public ParsedResume(Document resumeDoc) {
        sovrenCom.ConvertAndParseSoap sovren = new sovrenCom.ConvertAndParseSoap();        
        if (resumeDoc != null) {
            resumeText = sovren.DoConversionSimplified(EncodingUtil.Base64Encode(resumeDoc.body),'PLAIN_TEXT');
            resumeXML = sovren.ParseConvertedResume(resumeText , false, false, 5000, 2,'1', false,'1');
        }
    }
    
    /* Returns the contents of the first XML element by name 
     */
    public getFirstField(String fieldName) {
        XMLDom xmlDom = new XMLDom(resumeXML);
        return xmlDom.getElementsByTagName(fieldName).get(0).nodeValue;
    }
     
     
}