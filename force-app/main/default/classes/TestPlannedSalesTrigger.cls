@IsTest
private class TestPlannedSalesTrigger {
    @TestSetup
    static void Setup(){
        Planned_Sales__c ps1 = new Planned_Sales__c();
        ps1.Name = 'ps1';
        ps1.Car_Type__c = 'New';
        ps1.Year__c = 2024;
        ps1.Month__c = 10;
        insert ps1;
    }

    @IsTest
    static void testUniquePlannedSales_PositiveCase(){
        Planned_Sales__c ps2 = new Planned_Sales__c();
        ps2.Name = 'ps2';
        ps2.Car_Type__c = 'Used';  // Different car type
        ps2.Year__c = 2024;
        ps2.Month__c = 10;
        Test.startTest();
        insert ps2;
        Test.stopTest();
        System.assertEquals(1, [SELECT COUNT() FROM Planned_Sales__c WHERE Name = 'ps2']);
    }

    @IsTest
    static void testUniquePlannedSales_NegativeCase(){
        Planned_Sales__c ps3 = new Planned_Sales__c();
        ps3.Name = 'ps3';
        ps3.Car_Type__c = 'New';  
        ps3.Year__c = 2024;      
        ps3.Month__c = 10;        
        
        Test.startTest();
        try {
            insert ps3;
            System.assert(false, 'Expected exception was not thrown.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('A Planned Sales record already exists for this Year, Month, and Car Type.'));
        }
        Test.stopTest();
    }
    
    
}