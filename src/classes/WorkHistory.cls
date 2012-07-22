public with sharing class WorkHistory {

    private String companyName;
    private String jobTitle;
    private String description;
    private Date startDate;
    private Date endDate;
    private boolean current;
    
    public String getCompanyName(){
        return companyName;
    }
    
    public void setCompanyName(String companyName){
        this.companyName = companyName;
    }
    
    public String getJobTitle(){
        return jobTitle;
    }
    
    public void setJobTitle(String jobTitle){
        this.jobTitle = jobTitle;
    }
    
    public String getDescription(){
        return description;
    }
    
    public void setDescription(String description){
        this.description = description;
    }
    public Date getStartDate(){
        return startDate;
    }
    
    public void setStartDate(Date startDate){
        this.startDate = startDate;
    }
    public Date getEndDate(){
        return endDate;
    }
    
    public void setEndDate(Date endDate){
        this.endDate = endDate;
    }
    
    public boolean isCurrent(){
        return current; 
    }
    
    public void setCurrent(boolean current){
        this.current = current;
    }
}