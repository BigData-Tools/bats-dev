public class AAGeneralInformation{


    private String firstName;
    private String lastName;
    private String email;
    private String phoneNumber;
    private Integer postalCode;
    private String country;
    //It can be either state for US
    private String state;
    private String objective;
    private String executiveSummary;
    private String linkedInProfile;
    private String website;
    private String skype;
    private String streetAddress;
    private String city;
    
    private boolean applied;
    //which will determine the from where the applicant knew about the job opening
    private String advertMethod;
    //it can include the name of the employee referred him/her
    private String advertExplaination;

    public String getAdvertExplaination(){
        return advertExplaination;
    }
    
    public void setAdvertExplaination(String advertExplaination){
        this.advertExplaination = advertExplaination;
    }
    
    public String getAdvertMethod(){
        return advertMethod;
    }
    
    public void setAdvertMethod(String advertMethod){
    
    }
    
    public boolean getApplied(){
        return applied;
    }
    
    public void setApplied(boolean applied){
        this.applied = applied;
    }
    
    public String getCity(){
        return city;
    }
    
    public void setCity(String city){
        this.city = city;
    }
    
    public AAGeneralInformation(){
    
    }
    
    public void setStreetAddress(String streetAddress){
        this.streetAddress = streetAddress;
    }
    
    public String getStreetAddress(){
        return streetAddress;
    }
    
    public String getLinkedInProfile() {
        return linkedInProfile;
    }
    public void setLinkedInProfile(String linkedInProfile) {
        this.linkedInProfile = linkedInProfile;
    }
    public String getWebsite() {
        return website;
    }
    public void setWebsite(String website) {
        this.website = website;
    }
    public String getSkype() {
        return skype;
    }
    public void setSkype(String skype) {
        this.skype = skype;
    }
    
    public String getFirstName() {
        return firstName;
    }
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    public String getLastName() {
        return lastName;
    }
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getPhoneNumber() {
        return phoneNumber;
    }
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
    public Integer getPostalCode() {
        return postalCode;
    }
    public void setPostalCode(Integer postalCode) {
        this.postalCode = postalCode;
    }
    public String getCountry() {
        return country;
    }
    public void setCountry(String country) {
        this.country = country;
    }
    
    public String getState() {
        return state;
    }
    public void setState(String state) {
        this.state = state;
    }
    
    public String getObjective() {
        return objective;
    }
    public void setObjective(String objective) {
        this.objective = objective;
    }
    public String getExecutiveSummary() {
        return executiveSummary;
    }
    public void setExecutiveSummary(String executiveSummary) {
        this.executiveSummary = executiveSummary;
    }
}