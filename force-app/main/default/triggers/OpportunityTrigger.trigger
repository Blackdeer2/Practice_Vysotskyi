trigger OpportunityTrigger on Opportunity (before insert, before update, after insert, after update) {

    PlannedSalesHelper helper = new PlannedSalesHelper();
    OpportunityTriggerHandler handler = new OpportunityTriggerHandler();


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