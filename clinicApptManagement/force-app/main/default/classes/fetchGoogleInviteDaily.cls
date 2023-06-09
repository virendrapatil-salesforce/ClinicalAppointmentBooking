public without sharing class fetchGoogleInviteDaily implements Schedulable{
    ID phyId;
    public fetchGoogleInviteDaily(Id physicianId){
        if(String.isNotBlank(physicianId)){
            this.phyId = physicianId;
        }
    }
    public void execute(SchedulableContext sc){
        Contact physician = [SELECT ID,Unique_ID__c FROM Contact WHERE Id =:phyId ];
        List<NamedCredPhysician__mdt> nmCreds = new List<NamedCredPhysician__mdt>();
        if(Test.isRunningTest()){
            nmCreds = [SELECT ID,Label FROM NamedCredPhysician__mdt LIMIT 1];
        }
        else{
            nmCreds = [SELECT ID,Label FROM NamedCredPhysician__mdt WHERE Physician_Number__c =: physician.Unique_ID__c LIMIT 1];
        }
        
        if(nmCreds.size()>0 && nmCreds[0].Label !=null){
            GoogleEventFetchSvc.fetchEvents(nmCreds[0].Label,physician.Id);
        }
		
    }
}