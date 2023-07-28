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
    
    
    
    func saveContacts(_ contacts: [Contacts]) {
        let context = persistentContainer.viewContext
        for contact in contacts {
            var entity = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: context)
            as? Contacts
            entity?.id = Int(Int32(contact.id))
            entity?.firstName = contact.firstName
            entity?.lastName = contact.lastName
            entity?.phoneNumber = contact.phoneNumber
            entity?.email = contact.email
        }
        
        do{
            try context.save()
        }catch {
            print("Failed to ")
            
        }
    }
    
}
