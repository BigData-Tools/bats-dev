public class AAPreScreening{

    private String salaryRange;
    private boolean relocate;
    private boolean sponsoring;
    private String currentVisa;
    private Date joinDate;
    
    public AAPreScreening(){
    
    }

    public Date getJoinDate() {
        return joinDate;
    }

    public void setJoinDate(Date joinDate) {
        this.joinDate = joinDate;
    }
    
    public String getSalaryRange() {
        return salaryRange;
    }
    public void setSalaryRange(String salaryRange) {
        this.salaryRange = salaryRange;
    }
    public boolean getRelocate() {
        return relocate;
    }
    public void setRelocate(boolean relocate) {
        this.relocate = relocate;
    }
    public boolean getSponsoring() {
        return sponsoring;
    }
    public void setSponsoring(boolean sponsoring) {
        this.sponsoring = sponsoring;
    }
    public String getCurrentVisa() {
        return currentVisa;
    }
    public void setCurrentVisa(String currentVisa) {
        this.currentVisa = currentVisa;
    }

}