public with sharing class CaseHandler extends TriggerHandler  {

    private List<Case> triggerNew;
    private List<Case> triggerOld;
    private Map<Id, Case> triggerMapNew;
    private Map<Id, Case> triggerMapOld;

    public CaseHandler() {
        this.triggerOld = (List<Case>) Trigger.old;
        this.triggerNew = (List<Case>) Trigger.new;
        this.triggerMapNew = (Map<Id, Case>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, Case>) Trigger.oldMap;
    }

    public override void beforeInsert() {
        try {
            
        } catch (Exception e) {
            System.debug('Exception in beforeInsert of CaseHandler: ' + e.getMessage());
        }
    }

    public override void afterInsert() {
        try {
            
            Boolean isEmailCase = false;
            Boolean isWebCase = false;
            for (Case caseRecord : triggerNew) {
                if (caseRecord.Origin != null && caseRecord.Origin.equalsIgnoreCase('Email')) {
                    isEmailCase = true;
                    break;
                }                
                if (caseRecord.Origin != null && caseRecord.Origin.equalsIgnoreCase('Web')) {
                    isWebCase = true;
                    break;
                }
            }

            // If the case was created from an email, call handleNewCases
            if (isEmailCase) {
                CaseService.handleNewCases(this.triggerMapNew);
            }
            if (isWebCase) {
                CaseService.autoCreateCarService(this.triggerMapNew);
            }
        } catch (DmlException e) {
            System.debug('DML Exception in afterInsert of CaseHandler: ' + e.getMessage());
        } catch (Exception e) {
            System.debug('Exception in afterInsert of CaseHandler: ' + e.getMessage());
        }
    }

    public override void beforeUpdate() {
        try {
            
        } catch (DmlException e) {
            System.debug('DML Exception in beforeUpdate of CaseHandler: ' + e.getMessage());
        } catch (Exception e) {
            System.debug('Exception in beforeUpdate of CaseHandler: ' + e.getMessage());
        }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUpdate() {
        try {

        } catch (Exception e) {
            System.debug('Exception in afterUpdate of CaseHandler: ' + e.getMessage());
        }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void beforeDelete() {
        try {
            // Add your logic here if needed
        } catch (Exception e) {
            System.debug('Exception in beforeDelete of CaseHandler: ' + e.getMessage());
        }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterDelete() {
        try {
            // Add your logic here if needed
        } catch (Exception e) {
            System.debug('Exception in afterDelete of CaseHandler: ' + e.getMessage());
        }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUndelete() {
        try {
            // Add your logic here if needed
        } catch (Exception e) {
            System.debug('Exception in afterUndelete of CaseHandler: ' + e.getMessage());
        }
    }
}