//
//  ContactListViewController.swift
//  ContactsApp
//
//  Created by Lupu Emilian on 24.07.2023.
//

import UIKit

class ContactListViewController: UIViewController {
    
    //var tableView: UITableView!
    var userView: UITableView!
    var viewModel: ContactListViewModel!
    // var viewModel = ContactsViewModel()
    
    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Contacte"
        
       viewModel = ContactListViewModel()

       setupUI()
       setupUserTableView()
       getUsers()
       getContact()
       navigationController?.navigationBar.prefersLargeTitles = true

    }
    

  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchContactsFromCache()
        tableView.reloadData()
    }
    
    
   
    private func getUsers(){
        // API request and filter inactive users
        APIManager.shared.fetchUsersFromAPI {
            users in
            let activeUsers = users.filter{ $0.status != "inactive"}
            DispatchQueue.main.async {
                self.userView.reloadData()
            }
            print("Active Users: \(activeUsers)")
            //Cache the response locally
            APIManager.shared.cacheUsersLocally(users: activeUsers)
        }
    }
    
    private func getContact(){
        APIManager.shared.fetchContacts {_ in
         
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let headerTextView: UITextView = {
       let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "CONTACTELE MELE"
        textView.textColor = .systemGray
        textView.backgroundColor = .systemGray4
        textView.font = UIFont.boldSystemFont(ofSize: 17)
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 0, right: 0)
        return textView
        
    }()
    
    private func setupUI() {
      
        view.addSubview(tableView)
        view.addSubview(headerTextView)
        
        NSLayoutConstraint.activate([
            headerTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerTextView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: headerTextView.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
     
        headerTextView.isEditable = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: "ContactCell")
 

        let image = UIImage(systemName: "person.fill.badge.plus")
        let addButton = UIBarButtonItem(image: image, style: UIBarButtonItem.Style.done, target: self, action: #selector(addNewContactButtonTapped))
        addButton.tintColor = .gray
        
        navigationItem.rightBarButtonItem = addButton
    
    }
   
    
    func setupUserTableView()  {
        userView = UITableView(frame: view.bounds, style: .plain)
        userView.dataSource = self
        userView.delegate = self
        userView.register(UITableViewCell.self, forCellReuseIdentifier: "UserCell")
      
    }
    
    @objc func addNewContactButtonTapped(){
        let contactDetailsVC = ContactDetailsViewController()
        navigationController?.pushViewController(contactDetailsVC, animated: true)
       view.setNeedsDisplay()
    }

}


extension ContactListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contacts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactTableViewCell
        let contact = viewModel.contacts[indexPath.row]
        cell.configureCell(with: contact)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact = viewModel.contacts[indexPath.row]
        let contactDetailsVC = ContactDetailsViewController(contact: selectedContact)
        navigationController?.pushViewController(contactDetailsVC, animated: true)
    }
    
    
}
