public class DatabaseTransaction {

    private List<SObject> recordsToInsert;
    private Map<Id,SObject> recordsToUpdate; 
    private List<SObject> recordsToDelete;
    private Map<List<SObject>,Schema.sObjectField> relatedRecordsByRelationshipField;

    public DatabaseTransaction(){
        this.recordsToInsert = new List<SObject>();
        this.recordsToUpdate = new Map<Id,SObject>();
        this.recordsToDelete = new List<SObject>();
        this.relatedRecordsByRelationshipField = new Map<List<SObject>,Schema.sObjectField>();
    }

    public List<SObject> getRecordsToInsert(){
        return this.recordsToInsert;
    }

    public Map<Id,SObject> getRecordsToUpdate(){
        return this.recordsToUpdate;
    }

    public List<SObject> getRecordsToDelete(){
        return this.recordsToDelete;
    }

    public Map<List<SObject>,Schema.sObjectField> getRelationshipsToInsert(){
        return this.relatedRecordsByRelationshipField;
    }

    public void registerInsert(SObject record){
        recordsToInsert.add(record);
    }

    public void registerInsert(List<SObject> recordsToInsert){
        recordsToInsert.addAll(recordsToInsert);
    }

    public void registerRelationshipInsert(SObject parent, SObject child, Schema.sObjectField relationshipField){
        List<SObject> relatedRecords = new List<SObject>();
        relatedRecords.add(parent);
        relatedRecords.add(child);
        relatedRecordsByRelationshipField.put(relatedRecords,relationshipField);
    }

    public SObject getUniqueRecord(SObject record){
        return (recordsToUpdate.get(record.Id) != null ? recordsToUpdate.get(record.Id) : record);
    }

    public void registerUpdate(SObject record){
        if(Trigger.isBefore == null || !Trigger.isBefore){
            //put will replace if existing or add new if not
            recordsToUpdate.put(record.Id, record);
        }
    }

    public void registerDelete(List<SObject> recordsToDelete){
        recordsToDelete.addAll(recordsToDelete);
    }

    public void registerDelete(SObject record){
        recordsToDelete.add(record);
    }

    private List<SObject> getParentRecordsForInsert(Map<List<SObject>,Schema.sObjectField> relatedRecordsByRelationshipField){
        List<SObject> parentRecords = new List<SObject>();
        for(List<SObject> records : relatedRecordsByRelationshipField.keySet()){
            parentRecords.add(records[0]);
        }
        return parentRecords;
    }

    private List<SObject> getChildRecordsForUpsert(List<SObject> parentRecords){
        List<SObject> childRecords = new List<SObject>();
        List<Schema.sObjectField> relationshipFields = new List<Schema.sObjectField>(this.relatedRecordsByRelationshipField.values());
        for(List<SObject> records : relatedRecordsByRelationshipField.keySet()){
            childRecords.add(records[1]);
        }
        for(Integer i = 0; i < parentRecords.size(); i++){
            String fieldName = relationshipFields[i].getDescribe().getName();
            childRecords[i].put(fieldName, parentRecords[i].Id);
        }

        return childRecords;
    }

    public void doDML(){
        
     
        List<Database.SaveResult> resultInsert = database.insert(this.recordsToInsert);
            //TODO Error handling

        List<Database.SaveResult> resultUpdate = database.update(this.recordsToUpdate.values());
            //TODO Error handling

        if(this.recordsToDelete.size() > 0){
            //TODO Error handling
            List<Database.DeleteResult> resultDelete = database.delete(this.recordsToDelete);
        }

        List<SObject> parentRecords = this.getParentRecordsForInsert(relatedRecordsByRelationshipField);
        List<Database.SaveResult> resultParentInsert = database.insert(parentRecords);
        List<Database.UpsertResult> resultChildInsert = database.upsert(this.getChildRecordsForUpsert(parentRecords));

    }

}