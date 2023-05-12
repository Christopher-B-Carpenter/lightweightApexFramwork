public class SobjectBSelectorMock implements ISobjectBSelector {

    Static Integer fakeIdCounter = 1; 
    Static Map<Id,SObjectB> sobjectBsFromGetSobjectBs = new Map<Id, SObjectB>();
    
    public static String getFakeId(Schema.SObjectType type) {
        String result = String.valueOf(fakeIdCounter++);
        return type.getDescribe().getKeyPrefix() + '0'.repeat(12 - result.length()) + result;
    }
     
    public Map<Id,SObjectB> getSobjectBsById(Set<Id> sobjectAIds){

        if(sobjectBsFromGetSobjectBs.size() > 0){
            //return the existing list if already generated. This allows for associations to be created in tests 
            return sobjectsFromGetSobjectBs;
        }
        else{
            Map<Id,SObjectB> mockSObjectBs = new Map<Id,SObjectB>();

            for(Id sobjectA : sobjectAIds){
                SObjectB mockSObjectB = new SObjectB(
                    Id = getFakeId(Schema.SObjectB.SObjectType),
                    SObjectAID = sobjectA.Id
                    //add aditional fields here to match what is returned by the real selector query
                );
                mockSObjectBs.put(mockSObjectB.id,mockSObjectB);
            }
            
            sobjectsBFromGetSobjectBs = mockSObjectBs;
            return mockSObjectBs;
        }

    }
}