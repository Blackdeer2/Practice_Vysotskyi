@isTest
public class TestDataFactory {

    public static Account createAccount(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.BillingStreet = '123 Test St';
        acc.BillingCity = 'Test City';
        acc.BillingState = 'Test State';
        acc.BillingPostalCode = '12345';
        acc.BillingCountry = 'Test Country';

        insert acc;
        return acc;
    }
	public static Product2 createCar(String name, String brand, String model, String vinNumber, String condition, Decimal mileage,  Boolean doInsert) {
        Product2 car = new Product2();
        // car.Name = 'BMW X5';
        // car.Brand__C = 'BMW';
        // car.Model__c = 'X5';
        // car.VIN_Number__c = 'WBANV13578CZ74333';
        // car.Condition__c = 'New';
        // car.Mileage__c = 0;
        car.Name = name;
        car.Brand__C = brand;
        car.Model__c = model;
        car.VIN_Number__c = vinNumber;
        car.Condition__c = condition;
        car.Mileage__c = mileage;
		if(doInsert) {
			insert car;
		}
		return car;
	}

    public static Opportunity createOpportunity(String name, Date closeDate, String stageName, Id accountId,Id pricebookId, Boolean doInsert) {
        Opportunity opp = new Opportunity();
        opp.Name = name;
        opp.CloseDate = closeDate;
        opp.StageName = stageName;
        opp.AccountId = accountId;
        opp.Pricebook2Id = pricebookId;
        if (doInsert) {
            insert opp;
        }
        return opp;
    }

    public static OpportunityLineItem createOpportunityLineItem(Id opportunityId, Id product2Id, Decimal totalPrice, Boolean doInsert) {
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opportunityId;
        oli.Product2Id = product2Id;
        oli.TotalPrice = totalPrice;
        oli.Quantity = 1; 
        if (doInsert) {
            insert oli;
        }
        return oli;
    }

    public static Planned_Sales__c createPlannedSales(String name,String carType, Decimal year, Decimal month, Boolean doInsert) {
        Planned_Sales__c plannedSales = new Planned_Sales__c();
        plannedSales.Name = name;
        plannedSales.Car_Type__c = carType;
        plannedSales.Year__c = year;
        plannedSales.Month__c = month;
        if (doInsert) {
            insert plannedSales;
        }
        return plannedSales;
    }
}