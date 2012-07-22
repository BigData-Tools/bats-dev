public with sharing class AAWork {

    private String companyName;
    private String jobTitle;
    private String description;
    private Date startDate;
    private Date endDate;
    private boolean current;
    private double salary;
    private String jobType;
    private String department;
    private String paymentPeriod;
    private String city;
    private String state;
    private String country;
   
    
    public AAWork(){
    
    }
    
    public String getJobType(){
        return jobType;
    }
    
    public String getDepartment(){
        return department;
    }
    
    public void setDepartment(String department){
        this.department = department;
    }
    
    public String getPaymentPeriod(){
        return paymentPeriod;
    }
    
    public String getCity(){
        return city;
    }
    
    public String getState(){
        return state;
    }

    public String getCountry(){
        return country;
    }
    
    
    public void setJobType(String jobType){
        this.jobType = jobType;
    }
    
    public void setPaymentPeriod(String paymentPeriod){
        this.paymentPeriod = paymentPeriod;
    }
    
    public void setCity(String city){
        this.city = city;
    }   
    
    public void setState(String state){
        this.state = state;
    }
    
    public void setCountry(String country){
        this.country = country;
    }
    
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
    
    public double getSalary(){
        return salary;
    }
    
    public void setSalary(double salary){
        this.salary = salary;
    }
}