//
//  Contact.swift
//  ContactsApp
//
//  Created by Lupu Emilian on 25.07.2023.
//

import Foundation


struct Contacts: Decodable {
    var id: Int
    var firstName: String
    var lastName: String
    var phoneNumber: String?
    var email: String?
    var isActive: Bool
    
}


struct ContactsResponse: Decodable {
    var data: [Contacts]
}


struct User: Codable {
    let id: Int
    let name: String
    let email: String
    let gender: String
    let status: String
}



