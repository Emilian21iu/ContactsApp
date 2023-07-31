//
//  ContactsViewModel.swift
//  ContactsApp
//
//  Created by Lupu Emilian on 25.07.2023.
//

import Foundation
import CoreData

class ContactsViewModel {
    private var contacts: [Contacts] = []
    private var coreDataMager = CoreDataManager()
   
    //Fetch contacts from the API and save them in CoreData
    func fetchContacts(completion: @escaping () -> Void){
      //Use the shared APIManager to fetch contacts from the API
        APIManager.shared.fetchContacts { [weak self] activeContacts  in
            if let activeContacts =  activeContacts {
              //Save the fetched contacts in the view model's contacts array
                self?.contacts = activeContacts
                
              //Save the fetched contacts in CoreData using the CoreDataManager
                self?.coreDataMager.saveContacts(activeContacts)
            }
            
            //Call the completion block to notify the caller that the caller that the fetching is complete
            completion()
            
        }
    }
    
    //Get the number of contacts in the view model
    func numberOfContacts() -> Int {
        return contacts.count
    }
    
    //Get the contact at a specific index in the view model's contacts array
    func contact(at index: Int) -> Contacts {
        return contacts[index]
    }
    
}
