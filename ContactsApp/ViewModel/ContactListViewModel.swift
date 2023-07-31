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
    
    //The array to store the fetched contatcs
    var contacts: [ContactModel] = []
    
    
   //Fetch contacts from Core Data cache and populate the contacts array
    func fetchContactsFromCache() {
       //Get the AppDelegate instance to access the managed context
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
        //Obtain the managed context for Core Data operations
            let managedContext = appDelegate.persistentContainer.viewContext
        
        //Create a fetch request to retrieve the Contact entities from Core Data
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
            
            do {
                //Execute the fetch request and obtain the results
                let result = try managedContext.fetch(fetchRequest)
                
                //Clear the contacts array to start with a fresh list
                contacts = []
                
        //Loop through the fetched data and convert them into ContactModel objects
                for data in result as! [NSManagedObject] {
                    let id = data.value(forKey: "id") as! Int
                    let firstName = data.value(forKey: "firstName") as! String
                    let lastName = data.value(forKey: "lastName") as! String
                    let phoneNumber = data.value(forKey: "phoneNumber") as? String
                    let email = data.value(forKey: "email") as? String
                    
                    //Create a COntactModel object fro the fetched data
                    let contact = ContactModel(id: id, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email)
                    contacts.append(contact)
                }
            } catch let error as NSError {
                //Handle any errors that occur during fetching
                print("Error fetching contacts: \(error), \(error.userInfo)")
            }
        }

}
