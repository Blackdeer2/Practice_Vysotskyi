public with sharing class OpportunityLineItemService {

    public static void checkingOfReservedSoldCars(Map<Id, OpportunityLineItem> opportunityLineItemsMap ){

       if (opportunityLineItemsMap == null || opportunityLineItemsMap.isEmpty()) return;


        Set<Id> carsIds = new Set<Id>();

        for(OpportunityLineItem oli: opportunityLineItemsMap.values()){
            if (oli.Product2Id != null) {
            carsIds.add(oli.Product2Id);
            }
        }

        List<Product2> cars = [SELECT Id, Car_Status__c FROM Product2 WHERE Id IN :carsIds];

        Map<Id, String> carStatusMap = new Map<Id, String>();
        for (Product2 car : cars) {
            carStatusMap.put(car.Id, car.Car_Status__c);
        }

        for (OpportunityLineItem oli : opportunityLineItemsMap.values()) {
            String carStatus = carStatusMap.get(oli.Product2Id);

            if(carStatus == 'Sold'){
                oli.addError('Warning! This Opportunity has sold cars. You are not able to move forward with it, until you remove those cars, or they are back available.');
            }
            else if(carStatus == 'Reserved') {

                oli.addError('Warning! This Opportunity has reserved cars. You are not able to move forward until you remove those cars or they are back available.');
            }
            
        }
    }
}