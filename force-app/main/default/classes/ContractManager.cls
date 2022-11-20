@RestResource(urlMapping='/Contract/*')
global with sharing class ContractManager {
    
    @HttpPost
    global static Id createContract(Id accId, String ctrStatus, Date ctrStartDate, Integer ctrTerm){
        // Create a new contract
        Contract newContract = new Contract(
            AccountId = accId, 
            Status = ctrStatus, 
            StartDate = ctrStartDate, 
            ContractTerm = ctrTerm);

            insert newContract; 
            return newContract.Id;

    }

    @HttpPatch
    global static Id updateContract (){
      // Retrieve contract Id
        RestRequest request = RestContext.request;
        String contractId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Contract thisContract = [SELECT Id FROM Contract WHERE Id = :contractId];

        // Update the contract with Json content
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
          for (String fieldName : params.keySet()){
            thisContract.put(fieldName, params.get(fieldName));
          }
        update thisContract;
        return thisContract.Id;
    }
}
