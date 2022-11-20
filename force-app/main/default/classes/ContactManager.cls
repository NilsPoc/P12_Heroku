@RestResource(urlMapping='/Contact/*')
global with sharing class ContactManager {
    
    @HttpPost
    global static Id createContact (String ctFirstName, String ctLastName, String ctEmail, String ctPhone){

        List<Contact> contactByEmail = [SELECT Id FROM Contact WHERE Email =: ctEmail];
        // Check if contact (through email) is already existing 
        if (contactByEmail.size()>0) {
            return contactByEmail[0].Id;
        }
        // Create a new contact
        else {
            Contact newContact = new Contact (
                FirstName = ctFirstName,
                LastName = ctLastName,
                Phone = ctPhone,
                Email = ctEmail);
            insert newContact;
            return newContact.Id;
        }

    }

    @HttpPatch
    global static Id updateContact (){
        // Retrieve contact Id
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Contact thisContact = [SELECT Id FROM Contact WHERE Id = :contactId];

        // Update the contact with Json content
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
          for (String fieldName : params.keySet()){
            thisContact.put(fieldName, params.get(fieldName));
          }
        update thisContact;
        return thisContact.Id;
    }

    
    @HttpDelete
    global static Id deactivateContact (){
        // Retrieve contact Id and custom box Deactivated__c
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Contact contact = [SELECT Id, Deactivated__c FROM Contact WHERE Id = :contactId];
        // Deactivate contact 
        contact.Deactivated__c = true;  
        
        update contact;
        return contact.Id;
    }
    
}
