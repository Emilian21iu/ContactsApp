//
//  Contact.swift
//  ContactsApp
//
//  Created by Lupu Emilian on 25.07.2023.
//

import Foundation


struct Contacts: Decodable {
    
    //Properties
    var id: Int // Uniquie identifier for the contact
    var firstName: String
    var lastName: String
    var phoneNumber: String? // (optional)
    var email: String? // (optional)
    var isActive: Bool //Indicates whether the contact is active
    
}


//Represents the response containing an array of COntacts
struct ContactsResponse: Decodable {
    var data: [Contacts] // Array of COntacts objects
}


struct User: Codable {
    let id: Int  // Uniquie identifier for the contact
    let name: String
    let email: String
    let gender: String
    let status: String
}



