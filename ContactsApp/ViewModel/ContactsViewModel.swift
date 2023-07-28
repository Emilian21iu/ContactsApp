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
   
    func fetchContacts(completion: @escaping () -> Void){
        APIManager.shared.fetchContacts { [weak self] activeContacts  in
            if let activeContacts =  activeContacts {
                self?.contacts = activeContacts
                self?.coreDataMager.saveContacts(activeContacts)
            }
            completion()
            
        }
    }
    
    
    func numberOfContacts() -> Int {
        return contacts.count
    }
    
    func contact(at index: Int) -> Contacts {
        return contacts[index]
    }
    
}
