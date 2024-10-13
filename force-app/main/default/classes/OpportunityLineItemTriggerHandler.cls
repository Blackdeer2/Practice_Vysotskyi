public with sharing class OpportunityLineItemTriggerHandler extends TriggerHandler {
    private List<OpportunityLineItem> triggerNew;
    private List<OpportunityLineItem> triggerOld;
    private Map<Id, OpportunityLineItem> triggerMapNew;
    private Map<Id, OpportunityLineItem> triggerMapOld;
    
    public OpportunityLineItemTriggerHandler() {
        this.triggerOld = (List<OpportunityLineItem>) Trigger.old;
        this.triggerNew = (List<OpportunityLineItem>) Trigger.new;
        this.triggerMapNew = (Map<Id, OpportunityLineItem>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, OpportunityLineItem>) Trigger.oldMap;
    }

    public override void beforeInsert() {
        try {
            OpportunityLineItemService.checkingOfReservedSoldCars(this.triggerMapNew);
        } catch (Exception e) {
            System.debug('Exception in beforeInsert of OpportunityLineItemTriggerHandler: ' + e.getMessage());
        }
    }

    public override void afterInsert() {
        try {
            OpportunityLineItemService.checkingOfReservedSoldCars(this.triggerMapNew);
        } catch (DmlException e) {
            System.debug('DML Exception in afterInsert of OpportunityTriggerHandler: ' + e.getMessage());
        } catch (Exception e) {
            System.debug('Exception in afterInsert of OpportunityTriggerHandler: ' + e.getMessage());
        }
    }

    public override void beforeUpdate() {
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUpdate() {

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