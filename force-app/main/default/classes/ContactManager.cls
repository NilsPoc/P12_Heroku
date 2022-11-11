@RestResource(urlMapping='/Contact/*')
global with sharing class ContactManager {
    
    @HttpPost
    global static Id createContact (String ctFirstName, String ctLastName, String ctEmail, String ctPhone){

        List<Contact> contactByEmail = [SELECT Id FROM Contact WHERE Email =: ctEmail];

        if (contactByEmail.size()>0) {
            return contactByEmail[0].Id;
        }
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
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Contact thisContact = [SELECT Id FROM Contact WHERE Id = :contactId];

        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
          for (String fieldName : params.keySet()){
            thisContact.put(fieldName, params.get(fieldName));
          }
        update thisContact;
        return thisContact.Id;
    }
}
