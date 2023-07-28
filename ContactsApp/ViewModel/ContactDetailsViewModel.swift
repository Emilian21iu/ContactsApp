//
//  ContactDetailsViewModel.swift
//  ContactsApp
//
//  Created by Lupu Emilian on 24.07.2023.
//

import Foundation
import UIKit
import CoreData


class ContactDetailsViewModel {
    
    var contacts: [ContactModel] = []
    
    
    //Implement frunctions to save contacts in CoreData
    func saveContact(id: Int32,firstName: String, lastName: String, phoneNumber: String?, email: String?) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Contact", in: managedContext)!
            let contact = NSManagedObject(entity: entity, insertInto: managedContext)
            contact.setValue(id, forKey: "id")
            contact.setValue(firstName, forKey: "firstName")
            contact.setValue(lastName, forKey: "lastName")
            contact.setValue(phoneNumber, forKey: "phoneNumber")
            contact.setValue(email, forKey: "email")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error saving contact: \(error), \(error.userInfo)")
            }
        }
        
    
    //Implement frunctions to  update contacts in CoreData

    func updateContact(_ contact: ContactModel,  firstName: String, lastName: String, phoneNumber: String?, email: String?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
                    contact.firstName = firstName
                    contact.lastName = lastName
                    contact.phoneNumber = phoneNumber
                    contact.email = email
    
            
            do {
                
                let entity = NSBatchUpdateRequest(entityName: "Contact")
               
                entity.propertiesToUpdate = [
                        "firstName": firstName,
                        "lastName": lastName,
                        "phoneNumber": phoneNumber ?? "",
                        "email": email ?? ""
                    ]
                let predicate = NSPredicate(format: "lastName == %@", contact.lastName, contact.firstName, contact.email!, contact.phoneNumber!)
                
                entity.predicate = predicate
                
                entity.resultType = .updatedObjectIDsResultType
                
                try managedContext.execute(entity) as! NSBatchUpdateResult
                
                try managedContext.save()
            } catch let error as NSError {
                print("Error updating contact: \(error), \(error.userInfo)")
            
        }
    }
    
  
    
    //Implement frunctions to  delete contacts in CoreData
    
    func didDeleteContact(_ contact: ContactModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
      
            do{
                
//                let request = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Contact"))
                
                let fecthRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
                
                fecthRequest.predicate = NSPredicate(format: "firstName == %@", contact.firstName)
                
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fecthRequest)
                
                try managedContext.execute(deleteRequest)
              //  try managedContext.save()
                
            }catch{
                print("Error delete contact: \(error)")
            }
        
            
        
    }
    

}
