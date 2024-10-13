public with sharing class PlannedSalesHelper {

    public static void updateCarSales(Map<Id, Planned_Sales__c> plannedSalesMap){

        System.debug('PlannedSalesHelper.updateCarSales called');

        if (plannedSalesMap.isEmpty()) {

            System.debug('plannedSalesMap is empty');
            return;
        }

        List<OpportunityLineItem> oppLineItems = [SELECT Opportunity.Amount, TotalPrice, Opportunity.StageName, 
                                                         Opportunity.CloseDate, Product2.Name, Product2.Condition__c 
                                                   FROM OpportunityLineItem 
                                                   WHERE Opportunity.StageName = 'Closed Won' 
                                                   AND Product2.Condition__c != NULL];

        System.debug('OpportunityLineItems retrieved: ' + oppLineItems.size());

        Integer countOfCarsSold; 
        Double totalAmountEarned;


        Savepoint sp = Database.setSavepoint();
        try{
            for (Planned_Sales__c ps : plannedSalesMap.values()) {

                countOfCarsSold = 0; 
                totalAmountEarned = 0.0;

                for (OpportunityLineItem opp : oppLineItems) {

                    System.debug('Processing OpportunityLineItem: ' + opp.Id);

                    if ( dateComparison(ps.Year__c, ps.Month__c, opp.Opportunity.CloseDate) && opp.Product2.Condition__c == ps.Car_Type__c) {

                        countOfCarsSold++;
                        totalAmountEarned += opp.Opportunity.Amount;
                    }
                }
                ps.Count_of_Cars_Sold__c = (countOfCarsSold > 0) ? countOfCarsSold : 0;
                ps.Total_Amount_Earned__c = (totalAmountEarned > 0) ? totalAmountEarned : 0;

            }
        }catch(Exception e){

            Database.rollback(sp);
        }
    }

    private static Boolean dateComparison( Decimal psYear,  Decimal psMonth, Date oppCloseDate){

        Date psDateFormat = Date.newInstance(psYear.intValue(), psMonth.intValue(), 1);
        Date psDateEnd = psDateFormat.addMonths(1).addDays(-1);
        
        return (oppCloseDate <= psDateEnd) ? true : false;
    }


    public static void updateCarSalesByOpportunity(Map<Id, Opportunity> opportunities){

        if (opportunities.isEmpty()) return;

        List<OpportunityLineItem> oppLineItems = [SELECT Opportunity.Id, Opportunity.CloseDate, Opportunity.Amount, 
                                                         Product2.Condition__c 
                                                  FROM OpportunityLineItem 
                                                  WHERE OpportunityId IN :opportunities.keySet()];
        


        List<Planned_Sales__c> plannedSales = [SELECT Id, Year__c, Month__c, Car_Type__c 
                                                FROM Planned_Sales__c];
        Map<String, Planned_Sales__c> plannedSalesMap = new Map<String, Planned_Sales__c>();




        String planesSalesKey;
        for (Planned_Sales__c ps : plannedSales) {
            planesSalesKey = ps.Year__c + '-' + ps.Month__c + '-' + ps.Car_Type__c;
            plannedSalesMap.put(planesSalesKey, ps);
        }

        String opportunitykey;
        for (OpportunityLineItem oli: oppLineItems) {

        }

        for (Planned_Sales__c ps : plannedSalesMap.values()) {
            
            for (OpportunityLineItem oli : oppLineItems) {

                opportunitykey = String.valueOf(oli.Opportunity.CloseDate.year()) + '-' + String.valueOf(oli.Opportunity.CloseDate.month()) + '-' + oli.Product2.Condition__c;

                
                if (plannedSalesMap.containsKey(opportunitykey)) {
                    ps.Count_of_Cars_Sold__c += 1;
                    ps.Total_Amount_Earned__c += oli.TotalPrice;
    

    
                }
            }
            
        }
    
                update plannedSalesMap.values();
        
    }
}