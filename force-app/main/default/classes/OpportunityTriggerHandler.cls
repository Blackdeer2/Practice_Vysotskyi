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
        try {
            
        } catch (Exception e) {
            System.debug('Exception in beforeInsert of OpportunityTriggerHandler: ' + e.getMessage());
        }
    }

    public override void afterInsert() {
        try {
            // Add your logic here if needed
        } catch (DmlException e) {
            System.debug('DML Exception in afterInsert of OpportunityTriggerHandler: ' + e.getMessage());
        } catch (Exception e) {
            System.debug('Exception in afterInsert of OpportunityTriggerHandler: ' + e.getMessage());
        }

    }

    public override void beforeUpdate() {
        try {
            // Add your logic here if needed
        } catch (DmlException e) {
            System.debug('DML Exception in beforeUpdate of OpportunityTriggerHandler: ' + e.getMessage());
        } catch (Exception e) {
            System.debug('Exception in beforeUpdate of OpportunityTriggerHandler: ' + e.getMessage());
        }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUpdate() {
        try{

            Map<Id,Opportunity> opportunities = new Map<Id,Opportunity>();
            for(Opportunity opp : this.triggerMapNew.values()) {
                if (opp.StageName == 'Closed Won') {
                    opportunities.put(opp.Id, opp);
                }
            }
            if (!opportunities.isEmpty()) {
            PlannedSalesHelper.updateCarSalesByOpportunity(opportunities);
            }

            OpportunityService.automateCarStatus(this.triggerMapNew, this.triggerMapOld);
        }catch (Exception e) {
            System.debug('Exception in afterUpdate of OpportunityTriggerHandler: ' + e.getMessage());
        }

    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void beforeDelete() {
        try {
            // Add your logic here if needed
        } catch (Exception e) {
            System.debug('Exception in beforeDelete of OpportunityTriggerHandler: ' + e.getMessage());
        }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterDelete() {
        try{
            Map<Id, Opportunity> opportunities = new Map<Id, Opportunity>();
            for (Opportunity opp : this.triggerMapOld.values()) {
                if (opp.StageName == 'Closed Won') {
                    opportunities.put(opp.Id, opp);
                }
            }

            if (!opportunities.isEmpty()) {
                PlannedSalesHelper.updateCarSalesByOpportunity(opportunities);
            }
         }catch (Exception e) {
            System.debug('Exception in afterDelete of OpportunityTriggerHandler: ' + e.getMessage());
         }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUndelete() {
        try {
            // Add your logic here if needed
        } catch (Exception e) {
            System.debug('Exception in afterUndelete of OpportunityTriggerHandler: ' + e.getMessage());
        }
    }

}