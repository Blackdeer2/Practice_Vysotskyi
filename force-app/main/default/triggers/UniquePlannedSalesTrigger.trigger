trigger UniquePlannedSalesTrigger on Planned_Sales__c (before insert, before update) {

    for ( Planned_Sales__c newRecord : Trigger.new) {

        List<Planned_Sales__c> existingRecords  = [

        SELECT Id 
        FROM Planned_Sales__c 
        WHERE Year__c = :newRecord.Year__c
        AND Month__c = :newRecord.Month__c
        AND Car_Type__c = :newRecord.Car_Type__c
        AND Id != :newRecord.Id // Exclude the current record in case of update
        LIMIT 1
        ];

        if (!existingRecords.isEmpty()) {
            newRecord.addError('A Planned Sales record already exists for this Year, Month, and Car Type.');
        }
    }

}