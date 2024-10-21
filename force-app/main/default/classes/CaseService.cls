public with sharing class CaseService {

    public static void autoCreateCarService(Map<Id, Case> caseMap) {

        if (caseMap == null || caseMap.isEmpty()) return;
    
        Set<String> vinCodes = new Set<String>();
        for (Case caseRecord : caseMap.values()) {
            if (caseRecord.CarVinCode__c != null && !String.isBlank(caseRecord.CarVinCode__c)) {
                vinCodes.add(caseRecord.CarVinCode__c);
            }
        }
    
        List<Product2> cars = [SELECT Id, VIN_Number__c FROM Product2 WHERE VIN_Number__c IN :vinCodes];
        Map<String, Product2> vinToCarMap = new Map<String, Product2>();
        for (Product2 car : cars) {
            vinToCarMap.put(car.VIN_Number__c, car);
        }
    
        List<Car_Service__c> carServices = new List<Car_Service__c>();
    
        for (Case caseRecord : caseMap.values()) {
            if (caseRecord.CarVinCode__c != null) {
                Product2 matchedCar = vinToCarMap.get(caseRecord.CarVinCode__c);
                if (matchedCar != null) {
                    Car_Service__c newCarService = new Car_Service__c();
                    newCarService.Name = caseRecord.Subject;
                    newCarService.Service_Name__c = caseRecord.Subject;
                    newCarService.Description__c = caseRecord.Description;
                    newCarService.Date__c = Date.today();
                    newCarService.Car__c = matchedCar.Id;
                    newCarService.Case__c = caseRecord.Id;
                    carServices.add(newCarService);
                }
            }
        }
    
        if (!carServices.isEmpty()) {
            insert carServices;
        }
    }
    

    public static void handleNewCases(Map<Id, Case> caseMap) {
        System.debug('handleNewCases method called with caseMap: ' + caseMap);

        if (caseMap == null || caseMap.isEmpty()) return;

        Set<String> vinCodes = new Set<String>();
        Map<String, Case> vinToCaseMap = new Map<String, Case>();
    
        for (Case caseRecord : caseMap.values()) {
            String subject = caseRecord.Subject;
            System.debug('Processing case with subject: ' + subject);
            if (subject != null && subject.contains('VIN-')) {
                String vinCode = extractVinFromSubject(subject);
                System.debug('Extracted VIN code: ' + vinCode);
                if (vinCode != null && !String.isBlank(vinCode)) {
                    vinCodes.add(vinCode);
                    vinToCaseMap.put(vinCode, caseRecord);
                }
            }
        }
    
        List<Product2> cars = [SELECT Id, Brand__c, Model__c, VIN_Number__c 
                                FROM Product2
                                WHERE VIN_Number__c IN :vinCodes];
        System.debug('Queried cars: ' + cars);
    
        if (cars == null || cars.isEmpty()) {
            System.debug('No cars found for the provided VIN codes.');
            return;
        }
    
        List<Car_Service__c> carServices = new List<Car_Service__c>();
    
        for (Case caseRecord : caseMap.values()) {
            String vinCode = extractVinFromSubject(caseRecord.Subject);
            if (vinCode != null && vinToCaseMap.containsKey(vinCode)) {
                for (Product2 car : cars) {
                    if (car.VIN_Number__c == vinCode) {
                        System.debug('Creating Car Service for VIN: ' + car.VIN_Number__c);
    
                        Car_Service__c newCarService = new Car_Service__c();
                        newCarService.Name = caseRecord.Subject;
                        newCarService.Service_Name__c = caseRecord.Subject;
                        newCarService.Description__c = caseRecord.Description;
                        newCarService.Date__c = Date.today();
                        newCarService.Car__c = car.Id;
                        newCarService.Case__c = caseRecord.Id;
    
                        carServices.add(newCarService);
                    }
                }
            }
        }
    
        System.debug('Car services to insert: ' + carServices);
    
        if (carServices.size() > 0) {
            insert carServices;
            System.debug('Inserted Car Services successfully.');
        }
    }
    

    private static String extractVinFromSubject(String subject){

        Pattern vinPattern = Pattern.compile('VIN-(\\w+)');
        Matcher matcher = vinPattern.matcher(subject);
        if (matcher.find()) {
            return matcher.group(1);
        }
        return null;
    }

}