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

    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUpdate() {

        Map<Id,Opportunity> opportunities = new Map<Id,Opportunity>();
        for(Opportunity opp : this.triggerMapNew.values()) {
            if (opp.StageName == 'Closed Won') {
                opportunities.put(opp.Id, opp);
            }
        }
        if (!opportunities.isEmpty()) {
        PlannedSalesHelper.updateCarSalesByOpportunity(opportunities);
        }

    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void beforeDelete() {

    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterDelete() {

        Map<Id, Opportunity> opportunities = new Map<Id, Opportunity>();
        for (Opportunity opp : this.triggerMapOld.values()) {
            if (opp.StageName == 'Closed Won') {
                opportunities.put(opp.Id, opp);
            }
        }

        if (!opportunities.isEmpty()) {
            PlannedSalesHelper.updateCarSalesByOpportunity(opportunities);
        }

    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUndelete() {

    }

}