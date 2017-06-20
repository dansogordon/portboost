//
//  ContactsController.swift
//  Hijinnks
//
//  Created by adeiji on 5/11/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import Contacts

class ContactsController {
    
    class func getContacts () -> [CNContact] {
        return {
            let contactStore = CNContactStore()
            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactEmailAddressesKey,
                CNContactPhoneNumbersKey,
                CNContactImageDataAvailableKey,
                CNContactThumbnailImageDataKey] as [Any]
            
            // Get all the containers
            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
            } catch {
                print("Error fetching containers")
            }
            
            var results: [CNContact] = []
            
            // Iterate all containers and append their contacts to our results array
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                
                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                    
                    // Remove all contacts that do not have a name or that do not have a phone number
                    results = results.filter({ (contact) -> Bool in
                        return contact.phoneNumbers.count != 0 && contact.givenName != ""
                    })
                    // Put all the contacts in alphabetical order
                    results.sort(by: { (firstContact, secondContact) -> Bool in
                        return firstContact.givenName < secondContact.givenName
                    })
                } catch {
                    print("Error fetching results for container")
                }
            }
            
            return results
        }()
    }
    
}
