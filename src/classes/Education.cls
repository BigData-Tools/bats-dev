public class Education{

    public Education(){
    
    }

    private String instituteName;
    private double gpa;
    private double maxGpa;
    private String major;
    private boolean current;
    private boolean graduated;
    
    //Added newly
    private String degreeType;
    private String degreeName;
    
    
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
    
    public boolean isCurrent(){
        return current;
    }
    
    public void setCurrent(boolean current){
        this.current = current;
    }
    
    public boolean getGraduated(){
        return graduated;
    }
    
    public void setGraduated(boolean graduated){
        this.graduated = graduated;
    }
}