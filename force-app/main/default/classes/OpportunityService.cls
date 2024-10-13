public with sharing class OpportunityService {



    public static void automateCarStatus(Map<Id,Opportunity> opportunityMap, Map<Id, Opportunity> opportunityOldMap){

         string soldRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Product2' AND DeveloperName = 'Sold'].Id;
         string forSalesRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Product2' AND DeveloperName = 'For_Sale'].Id;

        if (opportunityMap.isEmpty()) {
            return;
        }

        List<OpportunityLineItem> oppLiteItem = [SELECT Opportunity.Id, Opportunity.StageName, Product2.Id, Product2.Car_Status__c 
                                                    FROM OpportunityLineItem
                                                    WHERE OpportunityId IN :opportunityMap.keySet()];

        List<Product2> carsToUpdate = new List<Product2>();

        for (Opportunity opp : opportunityMap.values()) {
            String newStage = opp.StageName;
            String oldStage = opportunityOldMap.get(opp.Id).StageName;

            for (OpportunityLineItem  oli : oppLiteItem) {

                if(oli.OpportunityId == opp.Id){
                    Product2 car = oli.Product2; 

                    if (newStage == 'Contract Sent') {
                        car.Car_Status__c = 'Reserved';
                    } else if (newStage == 'Closed Won') {
                        car.Car_Status__c = 'Sold';
                        car.RecordTypeId = soldRecordTypeId;
                    } else if (newStage == 'Closed Lost') {
                        car.Car_Status__c = 'Available';
                        car.RecordTypeId = forSalesRecordTypeId;
                    } else if (oldStage == 'Contract Sent' && newStage != 'Closed Won' && newStage != 'Closed Lost') {
                        car.Car_Status__c = 'Available';
                        car.RecordTypeId = forSalesRecordTypeId;
                    }
                    carsToUpdate.add(car);

                }
            } 
        }
        
        if (!carsToUpdate.isEmpty()) {
            update carsToUpdate;
        }
    }

}