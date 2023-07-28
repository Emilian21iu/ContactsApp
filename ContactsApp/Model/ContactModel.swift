//
//  Contact.swift
//  ContactsApp
//
//  Created by Lupu Emilian on 24.07.2023.
//

import Foundation


class ContactModel {
    var id: Int
    var firstName: String
    var lastName: String
    var phoneNumber: String?
    var email: String?
    
    init(id: Int, firstName: String, lastName: String, phoneNumber: String? = nil, email: String? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
    }
}
