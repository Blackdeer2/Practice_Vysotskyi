trigger PlannedSalesTrigger on Planned_Sales__c (before insert, before update, after insert, after update) {

    PlannedSalesTriggerHandler handler = new PlannedSalesTriggerHandler();

    try{
        if( Trigger.isInsert ){
            if(Trigger.isBefore) {
                handler.beforeInsert();
            }
            else {
                handler.afterInsert();
            }
        }
        else if ( Trigger.isUpdate ) {
            if(Trigger.isBefore){
                handler.beforeUpdate();
            }
            else{
                handler.afterUpdate();
            }
        }
    }catch (Exception e) {
        System.debug('Error in PlannedSalesTrigger: ' + e.getMessage());
    }


}