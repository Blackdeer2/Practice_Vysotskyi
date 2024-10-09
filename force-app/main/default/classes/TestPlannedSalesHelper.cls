/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestPlannedSalesHelper {

    @testSetup
    static void setupTestData() {

        Pricebook2 standardPricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
        Pricebook2 customPricebook = new Pricebook2(Name = 'Custom Pricebook', IsActive = true);
        insert customPricebook;


        Product2 carType1 = new Product2();
        carType1.Name = 'Sedan car1';
        carType1.Brand__c = 'car1';
        carType1.Model__c = 'lol';
        carType1.VIN_Number__c = 'WBANV13578CZ74051';
        carType1.Condition__c = 'New';
        carType1.Mileage__c = 0;

        Product2 carType2 = new Product2();
        carType1.Name = 'Sedan car2';
        carType1.Brand__c = 'car2';
        carType1.Model__c = 'lol2';
        carType1.VIN_Number__c = 'WBANV13578CZ74052';
        carType1.Condition__c = 'New';
        carType1.Mileage__c = 0;
        insert new List<Product2>{carType1, carType2};


        PricebookEntry pricebookEntry1 = new PricebookEntry(Pricebook2Id = standardPricebook.Id, Product2Id = carType1.Id, UnitPrice = 20000, IsActive = true);
        PricebookEntry pricebookEntry2 = new PricebookEntry(Pricebook2Id = customPricebook.Id, Product2Id = carType2.Id, UnitPrice = 35000, IsActive = true);
        insert new List<PricebookEntry>{pricebookEntry1, pricebookEntry2};

        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Opportunity 1';
        opp1.StageName = 'Closed Won';
        opp1.CloseDate = Date.newInstance(2023, 10, 1);
        opp1.Pricebook2Id = standardPricebook.Id;

        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Opportunity 2';
        opp2.StageName = 'Closed Won';
        opp2.CloseDate = Date.newInstance(2023, 9, 15);
        opp2.Pricebook2Id = customPricebook.Id;
        insert new List<Opportunity>{opp1, opp2};

        OpportunityLineItem oppLineItem1 = new OpportunityLineItem(OpportunityId = opp1.Id, PricebookEntryId = pricebookEntry1.Id, Quantity = 1, TotalPrice = 20000);
        OpportunityLineItem oppLineItem2 = new OpportunityLineItem(OpportunityId = opp2.Id, PricebookEntryId = pricebookEntry2.Id, Quantity = 1, TotalPrice = 35000);
        insert new List<OpportunityLineItem>{oppLineItem1, oppLineItem2};

        Planned_Sales__c ps1 = new Planned_Sales__c(Year__c = 2023, Month__c = 10, Car_Type__c = 'New');
        Planned_Sales__c ps2 = new Planned_Sales__c(Year__c = 2023, Month__c = 9, Car_Type__c = 'Used');
        insert new List<Planned_Sales__c>{ps1, ps2};

    }

    @isTest
    static void testUpdateCarSales() {
        
        Map<Id, Planned_Sales__c> plannedSalesMap = new Map<Id, Planned_Sales__c>([SELECT Id, Year__c, Month__c, Car_Type__c, Count_of_Cars_Sold__c, Total_Amount_Earned__c FROM Planned_Sales__c]);

        Test.startTest();
        PlannedSalesHelper.updateCarSales(plannedSalesMap);
        Test.stopTest();

        Planned_Sales__c ps1 = [SELECT Count_of_Cars_Sold__c, Total_Amount_Earned__c FROM Planned_Sales__c WHERE Car_Type__c = 'New' LIMIT 1];
        Planned_Sales__c ps2 = [SELECT Count_of_Cars_Sold__c, Total_Amount_Earned__c FROM Planned_Sales__c WHERE Car_Type__c = 'Used' LIMIT 1];

        System.assertEquals(1, ps1.Count_of_Cars_Sold__c, 'Count of Cars Sold for "New" type should be 1');
        System.assertEquals(20000.0, ps1.Total_Amount_Earned__c, 'Total Amount Earned for "New" type should be 20000');

        System.assertEquals(1, ps2.Count_of_Cars_Sold__c, 'Count of Cars Sold for "Used" type should be 1');
        System.assertEquals(35000.0, ps2.Total_Amount_Earned__c, 'Total Amount Earned for "Used" type should be 35000');
    }
}