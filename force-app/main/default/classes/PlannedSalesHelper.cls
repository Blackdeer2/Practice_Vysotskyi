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
    }

    private static Boolean dateComparison( Decimal psYear,  Decimal psMonth, Date oppCloseDate){

        Date psDateFormat = Date.newInstance(psYear.intValue(), psMonth.intValue(), 1);
        Date psDateEnd = psDateFormat.addMonths(1).addDays(-1);
        
        return (oppCloseDate <= psDateEnd) ? true : false;
    }


    public static void updateCarSalesByOpportunity(List<Opportunity> opportunities){

        if(opportunities.isEmpty()) return;

        Set<Id> oppIds = new Set<Id>();

        for (Opportunity opp : opportunities) {
            oppIds.add(opp.Id);
        }

        List<OpportunityLineItem> oppLineItems = [SELECT Opportunity.Id, Opportunity.CloseDate, Opportunity.Amount, 
                                                         Product2.Condition__c 
                                                  FROM OpportunityLineItem 
                                                  WHERE OpportunityId IN :oppIds];

        List<Planned_Sales__c> plannesSales = [SELECT Id, Year__c, Month__c, Car_Type__c
                                                FROM Planned_Sales__c];


        Integer countOfCarsSold; 
        Double totalAmountEarned;


        for (Planned_Sales__c ps : plannesSales) {

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
        
       
            update plannesSales;
        


    }
}