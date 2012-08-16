public class DashboardController{

public Integer getOfferInProgressNum() {
    return [SELECT count() FROM Application__c WHERE Status__c='Offer in process' AND CreatedDate<=NEXT_WEEK  AND (Recruiter__c = :UserInfo.getUserId() OR Hiring_Manager__c = :UserInfo.getUserId() OR Coordinator__c = :UserInfo.getUserId())];
}

public Integer getCodeRedNum() {
    return [SELECT count() FROM Candidate__c WHERE Code_Red__c=true AND CreatedDate<=NEXT_WEEK];
}

public LIST<Review__c> getTodayPhoneScreens () {
    LIST<Review__c> TodayPhoneScreens = new LIST<Review__c>();
    LIST<Review__c> reviews = [SELECT Application__c FROM Review__c WHERE (Interview__r.Interview_Type__c='Recruiter Screen' OR Interview__r.Interview_Type__c='HM Screen') AND Interview_Datetime__c = TODAY AND (Application__r.Recruiter__c = :UserInfo.getUserId() OR Application__r.Hiring_Manager__c = :UserInfo.getUserId() OR Application__r.Coordinator__c = :UserInfo.getUserId())]; 
    Set<String> reviewID = new Set<String>();
    for(Integer i = 0; i < reviews.size(); i++){
         reviewID.add(reviews[i].Application__c);           
    }
    Review__c review = new Review__c(); 
    Iterator<String> iterator = reviewID.iterator();
    while(iterator.hasNext()) {
         String applicationID = iterator.next();
         review = [SELECT Id, Application__c, Application__r.Name, Candidate_Formula__c, Position__c, Interview__r.Interview_Type__c FROM Review__c
                  WHERE Application__c = :applicationID].get(0);               
         TodayPhoneScreens.add(review); // contains distinct interviews
    } 
            
    return TodayPhoneScreens;         
}


public LIST<Review__c> getTodayOnsites () {
    LIST<Review__c> TodayOnsites = new LIST<Review__c>();
    LIST<Review__c> reviews = [SELECT Application__c FROM Review__c WHERE Interview__r.Interview_Type__c='Onsite Interview' AND Interview_Datetime__c = TODAY AND (Application__r.Recruiter__c = :UserInfo.getUserId() OR Application__r.Hiring_Manager__c = :UserInfo.getUserId() OR Application__r.Coordinator__c = :UserInfo.getUserId())]; 
    Set<String> reviewID = new Set<String>();
    for(Integer i = 0; i < reviews.size(); i++){
         reviewID.add(reviews[i].Application__c);           
    }
    Review__c review = new Review__c(); 
    Iterator<String> iterator = reviewID.iterator();
    while(iterator.hasNext()) {
         String applicationID = iterator.next();
         review = [SELECT Id, Application__c, Application__r.Name, Candidate_Formula__c, Position__c, Interview__r.Interview_Type__c FROM Review__c
                  WHERE Application__c = :applicationID].get(0);               
         TodayOnsites.add(review); // contains distinct interviews
    }
    
  
            
    return TodayOnsites;         
}

public LIST<Flagged_Junction__c> getFlaggedCandidates() {
    LIST<Flagged_Junction__c> Candidates = [SELECT Candidate__c FROM Flagged_Junction__c
                                            WHERE Commentor__r.User__c =: UserInfo.getUserId()];
    LIST<Application__c> applications = new LIST<Application__c>();
    for(Integer i = 0; i < Candidates.size(); i++){
        applications = [SELECT Position__c, Status__c FROM Application__c 
                        WHERE Candidate__c = :Candidates[i].Candidate__c];
    }
       
    LIST<Flagged_Junction__c> FlaggedCandidates = [SELECT Id, Name, Candidate__c, Candidate__r.First_Name__c, Candidate__r.Last_Name__c FROM Flagged_Junction__c
                                                   WHERE Commentor__r.User__c =: UserInfo.getUserId()];                 
       
    return FlaggedCandidates;   
                                   
}

public LIST<Application__c> getPendingCandidates(){
    LIST<Application__c> PendingCandidates = [SELECT Id, Name, Candidate_Formula__c, Position__c, Status__c  FROM Application__c
                                              WHERE (Status__c = 'New' OR Status__c = 'Recruiter Screen' OR Status__c = 'HM Screen' OR Status__c = 'Onsite Interview' OR Status__c = 'Offer in process') AND (Recruiter__c = :UserInfo.getUserId() OR Hiring_Manager__c = :UserInfo.getUserId() OR Coordinator__c = :UserInfo.getUserId())];
    
    return PendingCandidates;

}

public LIST<Application__c> getTeamQuarterlyHiredList(){
    LIST<Application__c> TeamQuarterlyHiredList = [SELECT Id, Candidate__r.First_Name__c, Candidate__r.Last_Name__c, Position__c, Position__r.Department__c, Source__c FROM Application__c WHERE Status__c = 'Accepted' AND Position__r.Open_Date__c = THIS_QUARTER];
    return TeamQuarterlyHiredList;
}

    
  

 /*------------ Tests only below this line ------------*/
    static testMethod void testDashboardController(){
    DashboardController dc = new DashboardController();
      dc.getOfferInProgressNum();
      dc.getCodeRedNum();
      dc.getTodayPhoneScreens();
      dc.getTodayOnsites();
      dc.getFlaggedCandidates();
      dc.getPendingCandidates();
      dc.getTeamQuarterlyHiredList();      
    }

 
}