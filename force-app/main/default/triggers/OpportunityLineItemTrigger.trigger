trigger OpportunityLineItemTrigger on OpportunityLineItem (before insert, before update, after insert, after update) {

    OpportunityLineItemTriggerHandler handler = new OpportunityLineItemTriggerHandler();


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