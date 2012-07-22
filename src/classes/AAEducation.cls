public class AAEducation{

    public AAEducation(){
    
    }

    private String instituteName;
    private double gpa;
    private double maxGpa;
    private String major;
    private String status;
    private String degreeType;
    private String degreeName;
    private String minor;
    private Date startDate;
    private Date endDate;
    
    
    public String getMinor(){
        return minor;
    }
    
    public Date getStartDate(){
        return startDate;
    }
    
    public Date getEndDate(){
       return endDate; 
    }
    
    public void setMinor (String minor){
        this.minor = minor;
    }
    
    
    public void setStartDate(Date startDate){
        this.startDate = startDate;
    }
    
    public void setEndDate (Date endDate){
        this.endDate = endDate;
    }
    
    public String getDegreeType(){
        return degreeType;
    }
    
    public void setDegreeType(String degreeType){
        this.degreeType = degreeType;
    }
    
    
    public String getDegreeName(){
        return degreeName;
    }
    
    public void setDegreeName(String degreeName){
        this.degreeName = degreeName;
    }
    
    public String getInstituteName(){
        return instituteName;
    }
    
    public void setInstituteName(String instituteName){
        this.instituteName = instituteName;
    }
    
    public double getGpa(){
        return gpa;
    }
    
    public void setGpa(double gpa){
        this.gpa = gpa;
    }
    
    public double getMaxGpa(){
        return maxGpa;
    }
    
    public void setMaxGpa(double maxGpa){
        this.maxGpa = maxGpa;
    }
    
    public String getMajor(){
        return major;
    }
    
    public void setMajor(String major){
        this.major = major;
    }
    
    public void setStatus(String status){
        this.status = status;
    }

    public String getStatus(){
        return status;
    }
}