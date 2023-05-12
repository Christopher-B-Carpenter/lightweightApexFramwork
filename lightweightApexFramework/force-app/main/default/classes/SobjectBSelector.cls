public class SobjectBSelector implements ISobjectBSelector {
    
    private String fields = 'Id';

    public Map<Id,SobjectB> getSobjectBsBySObjectAId(Set<Id> sobjectAIds){
        return new Map<id,SObjectB>((List<SObjectB>) database.query('SELECT ' + fields + ' FROM SObjectB where SObjectAId in :sobjectBIds'));
    }

}