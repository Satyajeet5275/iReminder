import Foundation
import Contacts

class FetchContacts {
    
    func fetchingContacts() -> [ContactInfo] {
        var contacts = [ContactInfo]()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        do {
            try CNContactStore().enumerateContacts(with: request) { (contact, stopPointer) in
                if let phoneNumber = contact.phoneNumbers.first?.value as? CNPhoneNumber {
                    let customPhoneNumber = PhoneNumber(stringValue: phoneNumber.stringValue)
                    contacts.append(ContactInfo(firstName: contact.givenName, lastName: contact.familyName, phoneNumber: customPhoneNumber))
                }
            }
        } catch let error {
            print("Failed", error)
        }
        
        contacts = contacts.sorted {
            $0.firstName < $1.firstName
        }
        return contacts
    }
}
