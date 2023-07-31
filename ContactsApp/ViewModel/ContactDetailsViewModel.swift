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
    
    //The array to store the fetched contatcs
    var contacts: [ContactModel] = []
    
    
    //Implement frunctions to new save contacts in CoreData
    func saveContact(id: Int32,firstName: String, lastName: String, phoneNumber: String?, email: String?) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
        
        //Obtain the managed context for CoreData opertaions
            let managedContext = appDelegate.persistentContainer.viewContext
        
        //Create new Contact entity and set its attributes with the provided data
            let entity = NSEntityDescription.entity(forEntityName: "Contact", in: managedContext)!
            let contact = NSManagedObject(entity: entity, insertInto: managedContext)
        
        
            contact.setValue(id, forKey: "id")
            contact.setValue(firstName, forKey: "firstName")
            contact.setValue(lastName, forKey: "lastName")
            contact.setValue(phoneNumber, forKey: "phoneNumber")
            contact.setValue(email, forKey: "email")
            
            do {
                //save the new contact in Core Data
                try managedContext.save()
            } catch let error as NSError {
                print("Error saving contact: \(error), \(error.userInfo)")
            }
        }
        
    
    //Implement frunctions to  update an existing contacts in CoreData
    func updateContact(_ contact: ContactModel,  firstName: String, lastName: String, phoneNumber: String?, email: String?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        //Obtain the managed context for CoreData opertaions
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //update the attributes of the existing contact with the provided data
                    contact.firstName = firstName
                    contact.lastName = lastName
                    contact.phoneNumber = phoneNumber
                    contact.email = email
    
            
            do {
            //Create a batch update request to update the contact in Core Data
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
                
               //execute the batch update request and save the changes
                try managedContext.execute(entity) as! NSBatchUpdateResult
                
                try managedContext.save()
            } catch let error as NSError {
                print("Error updating contact: \(error), \(error.userInfo)")
            
        }
    }
    
  
    
    //Implement frunctions to  delete contacts from CoreData
    func didDeleteContact(_ contact: ContactModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
            do{
//                let request = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Contact"))
                
        //Create a fetch request to find the COntact entity with the matching first name
                let fecthRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
                
                fecthRequest.predicate = NSPredicate(format: "firstName == %@", contact.firstName)
           
          //Create a batch delete request to delete the contact from Core Data
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fecthRequest)
              
             //Execute the bacth delete request to remove the contact
                try managedContext.execute(deleteRequest)
              //  try managedContext.save()
                
            }catch{
                print("Error delete contact: \(error)")
            }
        
            
        
    }
    

}
