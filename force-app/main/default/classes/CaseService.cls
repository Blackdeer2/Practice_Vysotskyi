public with sharing class CaseService {

    public static void autoCreateCarService(Map<Id, Case> caseMap){

        if (caseMap == null || caseMap.isEmpty()) return;

        Set<String> vinCodes = new Set<String>();
        for (Case caseRecord : caseMap.values()) {
            if (caseRecord.CarVinCode__c != null && !String.isBlank(caseRecord.CarVinCode__c)) {
                vinCodes.add(caseRecord.CarVinCode__c);
            }
        }

        List<Product2> cars = [SELECT Id, Brand__c, Model__c, VIN_Number__c 
                                FROM Product2
                                WHERE VIN_Number__c IN :vinCodes ];

        if (cars == null || cars.isEmpty()) return;

        List<Car_Service__c> carServices = new List<Car_Service__c>();

        for(Case caseRecord  : caseMap.values()){
            if(caseRecord .CarVinCode__c !=null ){  // || caseRecord .CarVinCode__c.isEmpty()
                for(Product2 car : cars){
                    if(car.VIN_Number__c == caseRecord .CarVinCode__c){ // && car.Brand__c == caseRecord .CarBrand__c

                        Car_Service__c newCarService = new Car_Service__c();
                        newCarService.Name = caseRecord .Subject;
                        newCarService.Service_Name__c = caseRecord .Subject;
                        newCarService.Description__c = caseRecord .Description;
                        newCarService.Date__c = Date.today();
                        newCarService.Car__c = car.Id;
                        
                        carServices.add(newCarService);
                    } 
                    
                    
                }
            }
        }

        if(carServices.size() > 0){
            insert carServices;
        }

    }

}