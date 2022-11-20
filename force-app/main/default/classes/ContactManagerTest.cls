@IsTest
public with sharing class ContactManagerTest {
    
    @IsTest
    public static void createContactTest() {
        // Check if createContact method is creating a new contact
        test.startTest();
        Id createdContactId = ContactManager.createContact('testFirstName', 'testLastName', 'testEmail.createContact@test.com', 'testPhone');
        System.assert(createdContactId != null);
        test.stopTest();
    }

    @IsTest
    public static void existingContactTest() {

        Contact newContact = new Contact (FirstName = 'testFirstName', LastName = 'testLastName', Email = 'testEmail.existingContact@test.com', Phone = 'testPhone');
        Insert newContact; 
        // Check if createContact method is not creating a new contact when its already existing
        Test.startTest();
        Id createdContactId = ContactManager.createContact('testFirstName', 'testLastName', 'testEmail.existingContact@test.com', 'testPhone');
        System.assert(newContact.Id == createdContactId); 
        Test.stopTest();
    }
    
    @IsTest
    public static void updateContactTest() {

        Contact newContact = new Contact (FirstName = 'testFirstName', LastName = 'testLastName', Email = 'testEmail.updateContact@test.com', Phone = 'testPhone');
        Insert newContact; 
        // Simulate a patch request with a new first name
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://projectoccom-dev-ed.develop.my.salesforce.com/services/apexrest/Contact/'
            + newContact.Id;
        request.httpMethod = 'PATCH';
        Request.addHeader('Content-Type', 'Application/Json');
        request.requestBody = Blob.valueOf('{"FirstName": "anotherTestName"}');
        RestContext.request = request;

        // Check if updateContact method is updating the contact (first name)
        Test.startTest();
        Id updatedContactId = ContactManager.updateContact();
        Test.stopTest();

        Contact updatedContact = [SELECT Id, FirstName FROM Contact WHERE Id = : updatedContactId];
        System.assert(updatedContact.FirstName == 'anotherTestName');
    }

    @IsTest
    public static void deactivateContactTest(){

        Contact newContact = new Contact (FirstName = 'testFirstName', LastName = 'testLastName', Email = 'testEmail.deactivateContact@test.com', Phone = 'testPhone');
        Insert newContact; 

        // Simulate a delete request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://projectoccom-dev-ed.develop.my.salesforce.com/services/apexrest/Contact/'
            + newContact.Id;
        request.httpMethod = 'DELETE';
        Request.addHeader('Content-Type', 'Application/Json');
        RestContext.request = request;

        Test.startTest(); 
        Id deactivatedContactId = ContactManager.deactivateContact();
        Test.stopTest();
        // Check if Deactivated__c has been set to true
        Contact deactivatedContact = [SELECT Id, Deactivated__c FROM Contact WHERE Id =:deactivatedContactId];
        System.assertEquals(deactivatedContact.Deactivated__c, true);  
    }


}
