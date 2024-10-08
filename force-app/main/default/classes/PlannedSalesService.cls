public with sharing class PlannedSalesService {

    public static void uniquePlannedSales(List<Planned_Sales__c> triggerNew){

        List<Planned_Sales__c> existingRecords  = [
        SELECT Id, Year__c, Month__c, Car_Type__c
        FROM Planned_Sales__c 
        ];

        for (Planned_Sales__c ps : triggerNew){
            for (Planned_Sales__c  existingRecord : existingRecords){
                if(existingRecord.Year__c == ps.Year__c &&
                   existingRecord.Month__c == ps.Month__c &&
                   existingRecord.Car_Type__c == ps.Car_Type__c &&
                   existingRecord.Id != ps.Id){

                     ps.addError('A Planned Sales record already exists for this Year, Month, and Car Type.');
                }
            }
        }
    }
}
