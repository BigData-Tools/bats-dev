public class AAAward{
    
    private String awardType;
    private String name;
    private String granter;
    private Date grantDate;
    private String reason;
    
    public AAAward(){
    
    }
    
    public String getAwardType() {
        return awardType;
    }
    
    public void setAwardType(String awardType) {
        this.awardType = awardType;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getGranter() {
        return granter;
    }
    
    public void setGranter(String granter) {
        this.granter = granter;
    }
    
    public Date getGrantDate() {
        return grantDate;
    }
    
    public void setGrantDate(Date grantDate) {
        this.grantDate = grantDate;
    }
    
    public String getReason() {
        return reason;
    }
    
    public void setReason(String reason) {
        this.reason = reason;
    }
}