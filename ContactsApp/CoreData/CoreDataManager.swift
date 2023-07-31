//
//  CoreDataManager.swift
//  ContactsApp
//
//  Created by Lupu Emilian on 25.07.2023.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    //Create and configure the persistent container for Core Data
    private var persistentContainer: NSPersistentContainer  = {
        let container = NSPersistentContainer(name: "Contact")
        container.loadPersistentStores{
            _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    
    // Save an array of Contacts objects into Core Data
    func saveContacts(_ contacts: [Contacts]) {
        let context = persistentContainer.viewContext
        for contact in contacts {
        //Insert a new contact entity into the context
            var entity = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: context)
            as? Contacts
       //Map the properties ot the COntacts object to the Core Data entityt
            entity?.id = Int(Int32(contact.id))
            entity?.firstName = contact.firstName
            entity?.lastName = contact.lastName
            entity?.phoneNumber = contact.phoneNumber
            entity?.email = contact.email
        }
        
        do{
            //save the changes tot the Core Data context
            try context.save()
        }catch {
            print("Failed to ")
            
        }
    }
    
}
