trigger OpportunityTrigger on Opportunity (before insert) {

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