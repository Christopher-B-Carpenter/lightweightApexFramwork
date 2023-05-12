public class SobjectAService {
    private DatabaseTransaction databaseTransaction;

    public SobjectService(DatabaseTransaction databaseTransaction) {
        this(new SobjectBSelector(), databaseTransaction);
    }

    public SobjectService(ISobjectBSelector sobjectBSelector, DatabaseTransaction databaseTransaction){
        this.databaseTransaction = databaseTransaction;
        this.sobjectBSelector = sobjectBSelector;
    }

    public void exampleUpdateTriggeringRecords(List<SObjectA> sobjectAs){

        for(SObjectA sobjectA : sobjectAs){

            //get unique record to update - in case the same record has been updated elsewhere.
            //This ensures that updates can be made to the same record in multiple places and still
            //collected for a single database transaction
            SObjectA sobjectA = (SObjectA) databaseTransaction.getUniqueRecord(sobjectA);
            //updates to sobjectA records

            //register the update regardless of if it is before or after context
            //this allows for methods to be reused in both contexts as needed
            //the database transaction class checks for the context before attempting DML
            databaseTransaction.registerUpdate(sobjectA);

        }
    }

}