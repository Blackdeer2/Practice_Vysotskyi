public with sharing class OpportunityTriggerHandler extends TriggerHandler {
    private List<Opportunity> triggerNew;
    private List<Opportunity> triggerOld;
    private Map<Id, Opportunity> triggerMapNew;
    private Map<Id, Opportunity> triggerMapOld;
    
    public OpportunityTriggerHandler() {
        this.triggerOld = (List<Opportunity>) Trigger.old;
        this.triggerNew = (List<Opportunity>) Trigger.new;
        this.triggerMapNew = (Map<Id, Opportunity>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, Opportunity>) Trigger.oldMap;
    }
    public override void beforeInsert() {

    }

    public override void afterInsert() {

    }

    public override void beforeUpdate() {
        List<Opportunity> closedWonOpportunities = new List<Opportunity>();
        for (Opportunity opp : this.triggerNew) {
            if (opp.StageName == 'Closed Won') {
                closedWonOpportunities.add(opp);
            }
        }

        if (!closedWonOpportunities.isEmpty()) {
            PlannedSalesHelper.updateCarSalesByOpportunity(closedWonOpportunities);
        }

    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUpdate() {

        OpportunityService.automateCarStatus(this.triggerMapNew, this.triggerMapOld);

    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void beforeDelete() {
        List<Opportunity> deletedOpportunities = Trigger.old;
        if (!deletedOpportunities.isEmpty()) {
            PlannedSalesHelper.updateCarSalesByOpportunity(deletedOpportunities);
        }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterDelete() {

    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUndelete() {

    }

}