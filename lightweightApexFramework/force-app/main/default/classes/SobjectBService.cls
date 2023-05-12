public class SobjectBService {

    private ISobjectSelector sobjectSelector;
    private DatabaseTransaction databaseTransaction;

    public SobjectService(DatabaseTransaction databaseTransaction) {
        this(new SobjectSelector(), databaseTransaction);
    }

    public SobjectService(ISobjectSelector sobjectSelector, DatabaseTransaction databaseTransaction){
        this.databaseTransaction = databaseTransaction;
        this.sobjectSelector = sobjectSelector;
    }

    public void exampleUpdateRelatedRecord(Set<Id> sobjectAIds){

        //query records to use data in method
        Map<Id,SObjectB> sobjectBs = sobjectBSelector.getSobjectBsById(sobjectAIds);


        for(SObjectB sobjectB : sobjectBs){

            //get unique record to update - in case the same record has been updated elsewhere.
            //This ensures that updates can be made to the same record in multiple places and still
            //collected for a single database transaction
            SObjectB sobjectB = (SObjectB) databaseTransaction.getUniqueRecord(sobjectB);
            //updates to sobjectA records

            //register the update regardless of if it is before or after context
            //this allows for methods to be reused in both contexts as needed
            //the database transaction class checks for the context before attempting DML
            databaseTransaction.registerUpdate(sobjectB);

        }

    }

    public void exampleInsertRelatedRecord(List<SObjectA> sobjectAs){
        //create new related record
        for(SObjectA sobjectA : sobjectAs){
            SObjectB sobjectB = new SObjectB(
                //set field values
            );

            //we would like to populate the Id of the new record into a lookup field on the existing SObjectA record
            //in order to do this we can use the registerRelationshipInsert method from the database class
            //this method will insert the SObjectB record and use the Id to update the specified field on the SObjectA record 
            databaseTransaction.registerRelationshipInsert(sobjectB, sobjectA, SObjectA.Some_Lookup_Field__c.getDescribe().getSObjectField());
        }

    }

}