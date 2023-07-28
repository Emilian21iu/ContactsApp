//
//  ContactListViewModel.swift
//  ContactsApp
//
//  Created by Lupu Emilian on 24.07.2023.
//

import Foundation
import UIKit
import CoreData


class ContactListViewModel {
    var contacts: [ContactModel] = []
    
    func fetchContactsFromCache() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
            
            do {
                let result = try managedContext.fetch(fetchRequest)
                contacts = []
                for data in result as! [NSManagedObject] {
                    let id = data.value(forKey: "id") as! Int
                    let firstName = data.value(forKey: "firstName") as! String
                    let lastName = data.value(forKey: "lastName") as! String
                    let phoneNumber = data.value(forKey: "phoneNumber") as? String
                    let email = data.value(forKey: "email") as? String
                    
                    let contact = ContactModel(id: id, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email)
                    contacts.append(contact)
                }
            } catch let error as NSError {
                print("Error fetching contacts: \(error), \(error.userInfo)")
            }
        }

}
