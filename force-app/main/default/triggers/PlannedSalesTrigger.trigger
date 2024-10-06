trigger PlannedSalesTrigger on Planned_Sales__c (before insert, before update, after insert, after update) {

    PlannedSalesTriggerHandler handler = new PlannedSalesTriggerHandler(Trigger.isExecuting, Trigger.size);


    if( Trigger.isInsert ){
        if(Trigger.isBefore) {
            handler.OnBeforeInsert(Trigger.New);
        }
        else {
            handler.OnAfterInsert(Trigger.New);
        }
    }
    else if ( Trigger.isUpdate ) {
        if(Trigger.isBefore){
            handler.OnBeforeUpdate(Trigger.New ,Trigger.Old,Trigger.NewMap,Trigger.OldMap);
        }
        else{
            handler.OnAfterUpdate(Trigger.New ,Trigger.Old,Trigger.NewMap,Trigger.OldMap);
        }
    }


}