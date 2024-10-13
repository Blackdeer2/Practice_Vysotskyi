@isTest
private class TestPlannedSalesHelper {
    @isTest
    static void testUpdateCarSales() {
        
        Pricebook2 standardPricebook = new PriceBook2();
        standardPricebook.Name = 'prbook';
        standardPricebook.IsActive = true;
        insert standardPricebook;
        

        Account acc = TestDataFactory.createAccount();

        Planned_Sales__c ps1 = TestDataFactory.createPlannedSales('plane', 'New', 2024, 12, true);

        Product2 car = TestDataFactory.createCar('BMW X5', 'BMW', 'X5', 'WBANV13578CZ74333', 'New', 0.0, true);
        
         PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = car.Id,
            UnitPrice = 10000,
            IsActive = true
        );
        insert pbe;

        Opportunity opp1 = TestDataFactory.createOpportunity('Test Opportunity 1', Date.newInstance(2024, 10, 1), 'Closed Won', acc.Id, standardPricebook.Id, true);
       
        OpportunityLineItem oli1 = TestDataFactory.createOpportunityLineItem(opp1.Id, car.Id, 10000.0, true);

        Map<Id, Planned_Sales__c> plannedSalesMap = new Map<Id, Planned_Sales__c>([SELECT Id, Year__c, Month__c, Car_Type__c FROM Planned_Sales__c]);

        Test.startTest();
        PlannedSalesHelper.updateCarSales(plannedSalesMap);
        Test.stopTest();

        Planned_Sales__c updatedPlannedSales  = [SELECT Count_of_Cars_Sold__c, Total_Amount_Earned__c FROM Planned_Sales__c WHERE Car_Type__c = 'New' LIMIT 1];
        //Planned_Sales__c ps2 = [SELECT Count_of_Cars_Sold__c, Total_Amount_Earned__c FROM Planned_Sales__c WHERE Car_Type__c = 'Used' LIMIT 1];

        System.assertEquals(1, updatedPlannedSales.Count_of_Cars_Sold__c, 'Count of Cars Sold for "New" type should be 1');
        System.assertEquals(10000.0, updatedPlannedSales .Total_Amount_Earned__c, 'Total Amount Earned for "New" type should be 20000');

        // System.assertEquals(1, ps2.Count_of_Cars_Sold__c, 'Count of Cars Sold for "Used" type should be 1');
        // System.assertEquals(35000.0, ps2.Total_Amount_Earned__c, 'Total Amount Earned for "Used" type should be 35000');
    }
}