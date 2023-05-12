@isTest
public class SobjectBServiceTest {
   
    @isTest
    public static void testExampleUpdateRelatedRecord(){
        SobjectBSelectorMock mockSobjectBSelector = new SobjectBSelectorMock();
        DatabaseTransaction databaseTransaction = new DatabaseTransaction();

        //create an instance of the service class and pass the mock selector
        SobjectBService sobjectBService = new SobjectBService(mockSobjectBSelector, databaseTransaction);

        //generate fake ids
        Set<Id> sobjectAIds = new Set<Id>();
        for(Integer i=1; i<5; i++){
            sobjectIds.add(Schema.SObjectA.SObjectType.getDescribe().getKeyPrefix() + '0'.repeat(11) + i);
        }

        test.startTest();
        //call service method with mock SObjectA ids, the service method will use the mock selector method to query
        //for SObjectB records 
        sobjectBService.exampleUpdateRelatedRecord(sobjectAIds);
        test.stopTest();

        //get the updates records that were registered with the databasetransaction class to check values
        List<SObjectB> updatedSObjectBs = (List<SObjectB>) databaseTransaction.getRecordsToUpdate().values();

        for(SObjectB updatedSObjectB : updatedSObjectBs){
            //asserts to check the updates to SObjectBs
            //if prior values are needed, call the mock selector before calling the service method to 
            //capture the initial values
        }

    }

    @isTest
    public static void testExampleInsertRelatedRecord(){

        DatabaseTransaction databaseTransaction = new DatabaseTransaction();

        //Because we don't need to query records, there's no need to pass a mock selector
        SobjectBService sobjectBService = new SobjectBService(databaseTransaction);

        Test.startTest();
        sobjectBService.exampleInsertRelatedRecord(sobjectAs);
        Test.stopTest();

        Map<List<SObject>,Schema.sObjectField> relationships = databaseTransaction.getRelationshipsToInsert();

        //asserts to check the data to insert

    }
}
