@IsTest
public with sharing class ContactManagerTest {
    
    @IsTest
    public static void createContactTest() {

        test.startTest();
        Id createdContactId = ContactManager.createContact('testFirstName', 'testLastName', 'testEmail.createContact@test.com', 'testPhone');
        System.assert(createdContactId != null);
        test.stopTest();
    }

    @IsTest
    public static void existingContactTest() {

        Contact newContact = new Contact (FirstName = 'testFirstName', LastName = 'testLastName', Email = 'testEmail.existingContact@test.com', Phone = 'testPhone');
        Insert newContact; 

        Test.startTest();
        Id createdContactId = ContactManager.createContact('testFirstName', 'testLastName', 'testEmail.existingContact@test.com', 'testPhone');
        System.assert(newContact.Id == createdContactId); 
        Test.stopTest();
    }
    
    @IsTest
    public static void updateContactTest() {

        Contact newContact = new Contact (FirstName = 'testFirstName', LastName = 'testLastName', Email = 'testEmail.updateContact@test.com', Phone = 'testPhone');
        Insert newContact; 

        RestRequest request = new RestRequest();
        request.requestUri =
            'https://projectoccom-dev-ed.develop.my.salesforce.com/services/apexrest/Contact/'
            + newContact.Id;
        request.httpMethod = 'PATCH';
        Request.addHeader('Content-Type', 'Application/Json');
        request.requestBody = Blob.valueOf('{"FirstName": "anotherTestName"}');
        RestContext.request = request;

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

        Contact deactivatedContact = [SELECT Id, Deactivated__c FROM Contact WHERE Id =:deactivatedContactId];
        System.assertEquals(deactivatedContact.Deactivated__c, true);  
    }


}
