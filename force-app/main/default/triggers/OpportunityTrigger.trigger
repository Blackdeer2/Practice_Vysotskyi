trigger OpportunityTrigger on Opportunity (before insert, before update, after insert, after update, before delete, after delete) {

    OpportunityTriggerHandler handler = new OpportunityTriggerHandler();
    try{
        List<TriggerControl__c> tcList = [SELECT Switch__c FROM TriggerControl__c LIMIT 1];

        if(tcList.size() > 0 && tcList[0].Switch__c == true){

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
            else if ( Trigger.isDelete ) {
                if(Trigger.isBefore){
                    handler.beforeDelete();
                }
                else{
                    handler.afterDelete();
                }
            }
        }
    }catch (Exception e) {
        System.debug('Error in PlannedSalesTrigger: ' + e.getMessage());
    }

}