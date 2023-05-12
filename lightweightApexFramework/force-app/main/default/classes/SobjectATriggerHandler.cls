public class SobjectATriggerHandler {

    DatabaseTransaction databaseTransaction = new DatabaseTransaction();
    SobjectBService sobjectAService = new SobjectAService(databaseTransaction);
    SobjectBService sobjectBService = new SobjectBService(databaseTransaction);

    public void isBefore(Map<Id, SObjectA> oldMap, List<SObjectA> newList) {	
        //Business/routing Logic + Call service class methods
    }    

    public void isBeforeInsert(List<SObjectA> newList){	
        //Business/routing Logic + Call service class methods
    }

    public void isBeforeUpdate(Map<Id, SObjectA> oldMap, List<SObjectA> newList){	
        sobjectAService.exampleUpdateTriggeringRecords(newList);
    }

    public void isBeforeDelete(Map<Id, SObjectA> oldMap){	
        //Business/routing Logic + Call service class methods	     	
    }
   
    public void isAfter(Map<Id, SObjectA> oldMap, List<SObjectA> newList){	
        //Business/routing Logic + Call service class methods							 
    }

    public void isAfterInsert(Map<Id, SObjectA> newMap){
       //Pass Ids from SObjectA to service method for SObjectB 
       //in the after context to make updates to the related SObjectB records
       sobjectBService.exampleUpdateRelatedRecord(sobjectAIds);    
    }
   
    public void isAfterUpdate(Map<Id, SObjectA> oldMap, List<SObjectA> newList){
       //Business/routing Logic + Call service class methods    	
    }
   
    public void isAfterDelete(Map<Id, SObjectA> oldMap){ 
       //Business/routing Logic + Call service class methods         		
    }

    public void isAfterUnDelete(Map<Id, SObjectA> newMap){	
        //Business/routing Logic + Call service class methods	 		
    }

    public void doDMl(){
        // execute DML when after context applicable
        databaseTransaction.doDML();
    }
}