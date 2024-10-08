trigger PlannedSalesTrigger on Planned_Sales__c (before insert, before update, after insert, after update) {

    PlannedSalesTriggerHandler handler = new PlannedSalesTriggerHandler();


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


}