public with sharing class PlannedSalesTriggerHandler {

    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob ;
    public static boolean isFromUploadAPI=false;
    
    public PlannedSalesTriggerHandler(boolean isExecuting, integer size)
    {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnBeforeInsert(List<Planned_Sales__c> newPlannedSales)
    {
        system.debug('PlannedSales Trigger On Before Insert');
        PlannedSalesService.uniquePlannedSales(newPlannedSales);
    }
    public void OnAfterInsert(List<Planned_Sales__c> newPlannedSales)
    {
        system.debug('PlannedSales Trigger On After Insert');
    }
    public void OnAfterUpdate( List<Planned_Sales__c> newPlannedSales, 
                               List<Planned_Sales__c> oldPlannedSales, 
                               Map<ID, Planned_Sales__c> newPlannedSalesMap , 
                               Map<ID, Planned_Sales__c> oldPlannedSalesMap )
    {
        system.debug('PlannedSales Trigger On After Update ');
    }
    public void OnBeforeUpdate( List<Planned_Sales__c> newPlannedSales, 
                                List<Planned_Sales__c> oldPlannedSales, 
                                Map<ID, Planned_Sales__c> newPlannedSalesMap , 
                                Map<ID, Planned_Sales__c> oldPlannedSalesMap )
    {
        system.debug('PlannedSales Trigger On Before Update ');
        PlannedSalesService.uniquePlannedSales(newPlannedSales);
    }

    @future 
    public static void OnAfterUpdateAsync(Set<ID> newPlannedSalesIDs)
    {

    }      
    public boolean IsTriggerContext
    {
        get{ return m_isExecuting;}
    }
    
    public boolean IsVisualforcePageContext
    {
        get{ return !IsTriggerContext;}
    }
    
    public boolean IsWebServiceContext
    {
        get{ return !IsTriggerContext;}
    }
    
    public boolean IsExecuteAnonymousContext
    {
        get{ return !IsTriggerContext;}
    }
}