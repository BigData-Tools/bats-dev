trigger schedule_email_job on Application__c (after insert) {
        
        //schedule date format ('ss mm HH dd MM ? yyyy');
        
        //String str = '0 0 09 ? * MON-FRI';
        //Scheduled_email_notice ser = new Scheduled_email_notice();
        //System.schedule('Check Idle Application', str, ser);
        
        
        //for delete scheduled job from system
        /*
        Settings__c s = Settings__c.getOrgDefaults();
        if (s != null){
            try{
                if (s.Schedule_ID__c != '' && s.Schedule_ID__c != null){
                    system.abortJob(s.Schedule_ID__c);
                }
            } catch (Exception e){
                // let it go b/c the job isn't scheduled
            }
        }
        */        
}