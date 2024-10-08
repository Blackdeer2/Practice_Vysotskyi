public with sharing class PlannedSalesTriggerHandler extends TriggerHandler {

    private List<Planned_Sales__c> triggerNew;
    private List<Planned_Sales__c> triggerOld;
    private Map<Id, Planned_Sales__c> triggerMapNew;
    private Map<Id, Planned_Sales__c> triggerMapOld;
    
    public PlannedSalesTriggerHandler() {
        this.triggerOld = (List<Planned_Sales__c>) Trigger.old;
        this.triggerNew = (List<Planned_Sales__c>) Trigger.new;
        this.triggerMapNew = (Map<Id, Planned_Sales__c>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, Planned_Sales__c>) Trigger.oldMap;
    }

    public override void beforeInsert() {

         PlannedSalesService.uniquePlannedSales(this.triggerNew);
    }

    public override void afterInsert() {

       try {
        PlannedSalesHelper.updateCarSales(this.triggerMapNew);
        } catch (DmlException e) {
            
            System.debug('Error updating Planned Sales: ' + e.getMessage());
        }

    }

    public override void beforeUpdate() {
        
        PlannedSalesHelper.updateCarSales(this.triggerMapNew);

    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUpdate() {

       
        PlannedSalesService.uniquePlannedSales(this.triggerNew);
        // try {
        //     PlannedSalesHelper.updateCarSales(this.triggerMapNew);
        // } catch (DmlException e) {
        //     System.debug('Error updating Planned Sales: ' + e.getMessage());
        // }
        
    }
    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void beforeDelete() {

    }
    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterDelete() {

    }
    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUndelete() {

    }

}