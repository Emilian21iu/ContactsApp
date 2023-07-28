//
//  ContactDetailsViewController.swift
//  ContactsApp
//
//  Created by Lupu Emilian on 24.07.2023.
//

import UIKit

class ContactDetailsViewController: UIViewController {
    
    
    var firstNameTextField: UITextField!
    var lastNameTextField: UITextField!
    var phoneNumberTextField: UITextField!
    var emailTextField: UITextField!
    var mainActionButton: UIButton!
    var deleteButon: UIButton!
    
    var viewModel: ContactDetailsViewModel!
    
    var contact: ContactModel?
    var isEditMode = false
    
    init(contact: ContactModel? = nil){
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        navigationItem.title = "Adaugă contact"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .white
        
        setupUI()
        viewModel  = ContactDetailsViewModel()
    }
    
    func updateTapContact(){
        let image = UIImage(systemName: "arrow.down.app.fill")
        let addButton = UIBarButtonItem(image: image, style: UIBarButtonItem.Style.done, target: self, action: #selector(mainActionButtonTapped))
        addButton.tintColor = .gray
        navigationItem.leftBarButtonItem = addButton
    }
    
    func addTapContact(){
        let image = UIImage(systemName: "plus.circle")
        let addButton = UIBarButtonItem(image: image, style: UIBarButtonItem.Style.done, target: self, action: #selector(mainActionButtonTapped))
        addButton.tintColor = .gray
        navigationItem.rightBarButtonItem = addButton
    }
    
    func deleteTapContact(){
        let image = UIImage(systemName: "xmark.circle")
        let addButton = UIBarButtonItem(image: image, style: UIBarButtonItem.Style.done, target: self, action: #selector(deleteButtonTapped))
        addButton.tintColor = .gray
        navigationItem.rightBarButtonItem = addButton
    }
    


    func setupUI() {
            // Set up UI elements and set their values based on the contact data if available
            firstNameTextField = UITextField(frame: CGRect(x: 20, y: 200, width: view.frame.width - 40, height: 60))
        firstNameTextField.placeholder = "NUME"
        firstNameTextField.backgroundColor = .white
        firstNameTextField.layer.cornerRadius = 10
        firstNameTextField.useUnderline()
        view.addSubview(firstNameTextField)
            
            lastNameTextField = UITextField(frame: CGRect(x: 20, y: 300, width: view.frame.width - 40, height: 60))
            lastNameTextField.placeholder = "PRENUME"
        lastNameTextField.backgroundColor = .white
        lastNameTextField.layer.cornerRadius = 10
        lastNameTextField.useUnderline()
            view.addSubview(lastNameTextField)
            
            phoneNumberTextField = UITextField(frame: CGRect(x: 20, y: 400, width: view.frame.width - 40, height: 60))
            phoneNumberTextField.placeholder = "TELEFON"
        phoneNumberTextField.backgroundColor = .white
        phoneNumberTextField.layer.cornerRadius = 10
        phoneNumberTextField.useUnderline()
            view.addSubview(phoneNumberTextField)
            
            emailTextField = UITextField(frame: CGRect(x: 20, y: 500, width: view.frame.width - 40, height: 60))
            emailTextField.placeholder = "EMAIL"
        emailTextField.backgroundColor = .white
        emailTextField.layer.cornerRadius = 10
        emailTextField.useUnderline()
            view.addSubview(emailTextField)
            
            mainActionButton = UIButton(frame: CGRect(x: 20, y: 700, width: view.frame.width - 40, height: 60))
        mainActionButton.backgroundColor = UIColor(red: 60/255, green: 190/255, blue: 90/255, alpha: 1.0)
        mainActionButton.layer.cornerRadius = 10
            mainActionButton.addTarget(self, action: #selector(mainActionButtonTapped), for: .touchUpInside)
            view.addSubview(mainActionButton)
            
        
        //Check if the contact is present
            if let contact = contact {
                firstNameTextField.text = contact.firstName
                lastNameTextField.text = contact.lastName
                phoneNumberTextField.text = contact.phoneNumber
                
                //Check if the email provided and set it to the email text field
                if let email = contact.email {
                    emailTextField.text = email
                }else {
                    emailTextField.text = ""
                }
                
                mainActionButton.setTitle("Actualizare", for: .normal)
                //deleteButon.isHidden = false
               // updateTapContact()
              deleteTapContact()
            } else {
                firstNameTextField.text = ""
                lastNameTextField.text = ""
                phoneNumberTextField.text = ""
                emailTextField.text = ""
                mainActionButton.setTitle("Salvează", for: .normal)
               // deleteButon.isHidden = true
               //addTapContact()
            }
        }
        
        @objc func mainActionButtonTapped() {
           let id = Int.random(in: 1...1000)
            let firstName = firstNameTextField.text ?? ""
            let lastName = lastNameTextField.text ?? ""
            var phoneNumber = phoneNumberTextField.text ?? ""
            let email = emailTextField.text ?? ""
            
            if firstName.isEmpty || lastName.isEmpty  {
                showErrorMessage(message: "Te rog introdu numele și prenumele în campurile obligatorii.")
                return
            }
            
            if !phoneNumber.isEmpty {
                // Format the phone number to the desired pattern (07XX XXX XXX)
              phoneNumber = formatPhoneNumber(phoneNumber)
                
            }
            
            if let contact = contact {
                // Update contact in CoreData
                viewModel.updateContact(contact,  firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email)
                
            } else {
                // Save new contact in CoreData
                viewModel.saveContact(id: Int32(id), firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email)
            }
            
            
            navigationController?.popViewController(animated: true)
        }
    
    
    @objc private func deleteButtonTapped() {
        if let contactToDelete = contact {
            let alert = UIAlertController(title: "Delete Contact", message: "Esti sigur ca vrei sa stergi contactul?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
                [weak self] (_) in
                self?.viewModel.didDeleteContact(contactToDelete)
                self?.navigationController?.popViewController(animated: true)
            }
          
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    


    func formatPhoneNumber(_ phoneNumber: String) -> String {
            // Remove all non-numeric characters from the phone number
            let digits = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            
            // Check if the phone number is empty or less than 7 digits
            guard digits.count >= 7 else {
                return phoneNumber // Return the original phone number if it doesn't have enough digits
            }
            
            // Get the first 3 digits of the phone number
            let areaCode = digits.prefix(3)
            
            // Get the next 3 digits of the phone number
            let nextThreeDigitsStartIndex = digits.index(digits.startIndex, offsetBy: 3)
            let nextThreeDigits = digits[nextThreeDigitsStartIndex..<digits.index(nextThreeDigitsStartIndex, offsetBy: 3)]
            
            // Get the last 3 digits of the phone number
            let lastThreeDigitsStartIndex = digits.index(digits.endIndex, offsetBy: -3)
            let lastThreeDigits = digits[lastThreeDigitsStartIndex..<digits.endIndex]
            
            // Combine the formatted phone number parts
            let formattedPhoneNumber = "07\(areaCode) \(nextThreeDigits) \(lastThreeDigits)"
            return formattedPhoneNumber
        }
    func showErrorMessage(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }


}

extension UITextField {
    func useUnderline() {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(origin: CGPoint(x: 0, y: self.frame.height - borderWidth), size: CGSize(width: self.frame.size.width, height: self.frame.height))
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
