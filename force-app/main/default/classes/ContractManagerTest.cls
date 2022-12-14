@IsTest
public with sharing class ContractManagerTest {
    
    @IsTest
    public static void createContractTest() {
        
        Account newAcc = new Account(Name = 'Test');
        insert newAcc;
        // Check if createContract method is creating a new contract
        test.startTest();
        Id createdContractId = ContractManager.createContract(newAcc.Id, 'Draft', system.today()+1, 9);
        System.assert(createdContractId != null);
        test.stopTest();
    }
    
    @IsTest
    public static void updateContractTest() {

        Account newAcc = new Account(Name = 'Test');
        insert newAcc;

        Contract newContract = new Contract(AccountId = newAcc.Id, Status = 'Draft', StartDate = system.today()+1, ContractTerm = 9);
        Insert newContract; 
        // Simulate a patch request with a new status
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://projectoccom-dev-ed.develop.my.salesforce.com/services/apexrest/Contract/'
            + newContract.Id;
        request.httpMethod = 'PATCH';
        Request.addHeader('Content-Type', 'Application/Json');
        request.requestBody = Blob.valueOf('{"Status": "Activated"}');
        RestContext.request = request;
        
        // Check if updateContract method is updating the contract (status)
        test.startTest();
        Id updatedContractId = ContractManager.updateContract();
        test.stopTest(); 

        Contract updatedContract = [SELECT Id, Status FROM Contract WHERE Id = :updatedContractId];
        System.assertEquals('Activated', updatedContract.Status);
    }
}
