@isTest
private class TestCaseTrigger {

    @isTest
    static void testAutoCreateCarService_Positive() {

        String name = 'BMW X5';
        String brand = 'BMW';
        String model = 'X5';
        String vinNumber = 'WBANV13578CZ74051';
        String condition ='New';
        Decimal mileage = 0.0;
        
        Product2 testCar = TestDataFactory.createCar(name, brand, model, vinNumber, condition, mileage);

        // Create a test Case record with the matching VIN
        Case testCase = TestDataFactory.createCaseWeb();

        // Execute the method to create related Car Service records
        Test.startTest();
        CaseService.autoCreateCarService(new Map<Id, Case>{testCase.Id => testCase});
        Test.stopTest();

        // Verify that only one Car_Service__c record was created
        List<Car_Service__c> createdServices = [SELECT Id, Name, Service_Name__c, Description__c, Car__c, Case__c FROM Car_Service__c WHERE Case__c = :testCase.Id];
        
        // Ensure that only one record is created
        System.assertEquals(1, createdServices.size(), 'Should create one Car_Service__c record.');
        System.assertEquals(testCar.Id, createdServices[0].Car__c, 'Car_Service__c should be linked to the correct car.');
    }

    @isTest
    static void testAutoCreateCarService_Negative() {
        // Create a test Case record with a VIN that does not exist
        Case caseWithDifferentVin = new Case(
            SuppliedName = 'Test User',
            SuppliedEmail = 'testuser@example.com',
            SuppliedPhone = '987654321',
            CarVinCode__c = 'VIN-54321', // Using a non-existent VIN
            Subject = 'Service Request with Unknown VIN',
            Description = 'Service request for testing with unknown VIN.'
        );
        insert caseWithDifferentVin;

        // Execute the method
        Test.startTest();
        CaseService.autoCreateCarService(new Map<Id, Case>{caseWithDifferentVin.Id => caseWithDifferentVin});
        Test.stopTest();

        // Check that no Car_Service__c record was created
        List<Car_Service__c> servicesForDifferentVin = [SELECT Id FROM Car_Service__c WHERE Case__c = :caseWithDifferentVin.Id];
        System.assertEquals(0, servicesForDifferentVin.size(), 'Car_Service__c should not be created for unknown VIN.');
    }
}