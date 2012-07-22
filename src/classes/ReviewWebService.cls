/* Note from Eric:
* I was planning on using this class to allow GAE to PUSH data into Force.
* The authentication related to doing the PUSH was too difficult. 
* Therefore this class is not being used. I am leaving it here for reference
* in case someone wants to try again.
*/

global class ReviewWebService {
    webService static void addComments(String comments, Id reviewId) {
        Review__c review = [SELECT Review__c.Name FROM Review__c WHERE Id = :reviewId];
        review.Comments__c = comments;
        return;
    }
}