public class AACertification{

    private String name;
    private String vendor;
    private Date issueDate;
    private Date expiryDate;
    
    public AACertification(){
    
    }
    
    public String getName(){
       return name;
    }
    
    public String getVendor(){
        return vendor;
    }
    
    public Date getIssueDate(){
        return issueDate;
    }
    
    public Date getExpiryDate(){
        return expiryDate;
    }
    
    public void setName(String name){
        this.name = name;
    }

    public void setVendor(String vendor){
        this.vendor = vendor;
    }
    
    public void setIssueDate(Date issueDate){
        this.issueDate = issueDate;
    }
    
    public void setExpiryDate(Date expiryDate){
        this.expiryDate = expiryDate;
    }
}