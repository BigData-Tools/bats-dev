public class OpenPosition {
   //Get record for the Business Operations Department
    public ApexPages.StandardSetController setBusiness {
        get {
            if(setBusiness == null) {
                setBusiness = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Name FROM Position__c WHERE Department__c = 'Business Operations'
                    And Open_Date__c <= TODAY And Close_Date__c >= TODAY]));
            }
            return setBusiness;
        }
        set;
    }

    
    public List<Position__c> getBusinessPositions() {
        return (List<Position__c>) setBusiness.getRecords();
    }
    
    //Get record for the Customer Success Department
    public ApexPages.StandardSetController setCustomer {
        get {
            if(setCustomer == null) {
                setCustomer = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Name FROM Position__c WHERE Department__c = 'Customer Success'
                    And Open_Date__c <= TODAY And Close_Date__c >= TODAY]));
            }
            return setCustomer;
        }
        set;
    }

    
    public List<Position__c> getCustomerPositions() {
        return (List<Position__c>) setCustomer.getRecords();
    }
    
    
    //Get record for the Design Department
    public ApexPages.StandardSetController setDesign {
        get {
            if(setDesign == null) {
                setDesign = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Name FROM Position__c WHERE Department__c = 'Design'
                    And Open_Date__c <= TODAY And Close_Date__c >= TODAY]));
            }
            return setDesign;
        }
        set;
    }

    
    public List<Position__c> getDesignPositions() {
        return (List<Position__c>) setDesign.getRecords();
    }
    
    //Get record for the Engineering Department
     public ApexPages.StandardSetController setEngineering {
        get {
            if(setEngineering == null) {
                setEngineering = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Name FROM Position__c WHERE Department__c = 'Engineering'
                    And Open_Date__c <= TODAY And Close_Date__c >= TODAY]));
            }
            return setEngineering;
        }
        set;
    }
   
    public List<Position__c> getEngineeringPositions() {
        return (List<Position__c>) setEngineering.getRecords();
    }
    
    //Get record for the Marketing Department
     public ApexPages.StandardSetController setMarketing {
        get {
            if(setMarketing == null) {
                setMarketing = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Name FROM Position__c WHERE Department__c = 'Marketing'
                    And Open_Date__c <= TODAY And Close_Date__c >= TODAY]));
            }
            return setMarketing;
        }
        set;
    }
  
    public List<Position__c> getMarketingPositions() {
        return (List<Position__c>) setMarketing.getRecords();
    }
    
    //Get record for the Product and Platform Department
    public ApexPages.StandardSetController setProduct {
        get {
            if(setProduct == null) {
                setProduct = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Name FROM Position__c WHERE Department__c = 'Product and Platform'
                    And Open_Date__c <= TODAY And Close_Date__c >= TODAY]));
            }
            return setProduct;
        }
        set;
    }
  
    public List<Position__c> getProductPositions() {
        return (List<Position__c>) setProduct.getRecords();
    }
    
    //Get record for the Sales Department
    public ApexPages.StandardSetController setSales {
        get {
            if(setSales == null) {
                setSales = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Name FROM Position__c WHERE Department__c = 'Sales'
                    And Open_Date__c <= TODAY And Close_Date__c >= TODAY]));
            }
            return setSales;
        }
        set;
    }
  
    public List<Position__c> getSalesPositions() {
        return (List<Position__c>) setSales.getRecords();
    }
    
     //Get record for the Technical Operations Department
    public ApexPages.StandardSetController setTechnical {
        get {
            if(setTechnical == null) {
                setTechnical= new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Name FROM Position__c WHERE Department__c = 'Technical Operations'
                    And Open_Date__c <= TODAY And Close_Date__c >= TODAY]));
            }
            return setTechnical;
        }
        set;
    }
  
    public List<Position__c> getTechnicalPositions() {
        return (List<Position__c>) setTechnical.getRecords();
    }
    
    //Get record for the Other Department
    public ApexPages.StandardSetController setOther {
        get {
            if(setOther == null) {
                setOther= new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Name FROM Position__c WHERE Department__c = ''
                    And Open_Date__c <= TODAY And Close_Date__c >= TODAY]));
            }
            return setOther;
        }
        set;
    }
    
    public List<Position__c> departmentPosition{
        get{
            try{
                String departmentName = ApexPages.currentPage().getParameters().get('department');
                if(departmentName.equalsIgnoreCase('business operations')){
                    return getBusinessPositions();
                }else if(departmentName.equalsIgnoreCase('customer success')){
                    return getCustomerPositions();
                }else if(departmentName.equalsIgnoreCase('design')){
                    return getDesignPositions();
                }else if(departmentName.equalsIgnoreCase('engineering')){
                    return getEngineeringPositions();
                }else if(departmentName.equalsIgnoreCase('marketing')){
                    return getMarketingPositions();
                }else if(departmentName.equalsIgnoreCase('product and platform')){
                    return getProductPositions();
                }else if(departmentName.equalsIgnoreCase('sales')){
                    return getSalesPositions();
                }else if(departmentName.equalsIgnoreCase('technical operations')){
                    return getTechnicalPositions();
                }else{
                    return getOtherPositions();
                }
            }catch(Exception e){
                return new List<Position__c>();
            }
        }
        set;
    }
  
    public List<Position__c> getOtherPositions() {
        return (List<Position__c>) setOther.getRecords();
    }
    
     /*------------ Tests only below this line ------------*/
    static testMethod void testOpenPosition(){
    OpenPosition ttt = new OpenPosition();
    ttt.getBusinessPositions();
    ttt.getCustomerPositions();
    ttt.getDesignPositions();
    ttt.getEngineeringPositions();
    ttt.getMarketingPositions();
    ttt.getProductPositions();
    ttt.getSalesPositions();
    ttt.getTechnicalPositions();
    ttt.getOtherPositions();
    
    List<Position__c> dp = ttt.departmentPosition;
    
    }
    
}