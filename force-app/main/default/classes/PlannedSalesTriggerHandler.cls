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
        try {
            PlannedSalesHelper.updateCarSales(this.triggerMapNew);
            PlannedSalesService.uniquePlannedSales(this.triggerNew);
        } catch (Exception e) {
            System.debug('Exception in beforeInsert of PlannedSalesTriggerHandler: ' + e.getMessage());
        }
    }

    public override void afterInsert() {
        // try {
        //     PlannedSalesHelper.updateCarSales(this.triggerMapNew);
        // } catch (DmlException e) {
        //     System.debug('DML Exception in afterInsert of PlannedSalesTriggerHandler: ' + e.getMessage());
        // } catch (Exception e) {
        //     System.debug('Exception in afterInsert of PlannedSalesTriggerHandler: ' + e.getMessage());
        // }
    }

    public override void beforeUpdate() {
        try {
            PlannedSalesHelper.updateCarSales(this.triggerMapNew);
        } catch (DmlException e) {
            System.debug('DML Exception in beforeUpdate of PlannedSalesTriggerHandler: ' + e.getMessage());
        } catch (Exception e) {
            System.debug('Exception in beforeUpdate of PlannedSalesTriggerHandler: ' + e.getMessage());
        }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUpdate() {
        try {
            PlannedSalesService.uniquePlannedSales(this.triggerNew);
        } catch (Exception e) {
            System.debug('Exception in afterUpdate of PlannedSalesTriggerHandler: ' + e.getMessage());
        }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void beforeDelete() {
        try {
            // Add your logic here if needed
        } catch (Exception e) {
            System.debug('Exception in beforeDelete of PlannedSalesTriggerHandler: ' + e.getMessage());
        }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterDelete() {
        try {
            // Add your logic here if needed
        } catch (Exception e) {
            System.debug('Exception in afterDelete of PlannedSalesTriggerHandler: ' + e.getMessage());
        }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUndelete() {
        try {
            // Add your logic here if needed
        } catch (Exception e) {
            System.debug('Exception in afterUndelete of PlannedSalesTriggerHandler: ' + e.getMessage());
        }
    }
}
