//
//  ContactListViewController.swift
//  ContactsApp
//
//  Created by Lupu Emilian on 24.07.2023.
//

import UIKit

class ContactListViewController: UIViewController {
    
    
    
    //Properties
    //var tableView: UITableView!
    var userView: UITableView!
    var viewModel: ContactListViewModel!
    // var viewModel = ContactsViewModel()
    
    
    //Array o store the fetched users
    var users: [User] = []

    
    //Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Contacte"
        
       viewModel = ContactListViewModel()

       setupUI()// Set up the user interface elements
       setupUserTableView() // Set up the userView
       getUsers() //  Fetch user data from the API and filter inactive users
       getContact()//Fetch contact data from the API
       navigationController?.navigationBar.prefersLargeTitles = true

    }
    

  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchContactsFromCache()
        tableView.reloadData()
    }
    
    
   
    //Networking Methods
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
    
    //fetch contact data fro the API
    private func getContact(){
        APIManager.shared.fetchContacts {_ in
         //Handle contacts response, if needed
        }
    }
    
    
    //UI setup methods
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
      // add the headerTextView and tableView as subviews
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
 
     //Set up the right bar button
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
    
    //Button action method
    @objc func addNewContactButtonTapped(){
        let contactDetailsVC = ContactDetailsViewController()
        navigationController?.pushViewController(contactDetailsVC, animated: true)
       view.setNeedsDisplay()
    }

}


//UITableView  DataSource and Delegate Methods
extension ContactListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contacts.count // return the number of contacts in the viewModel
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactTableViewCell
        let contact = viewModel.contacts[indexPath.row]
        cell.configureCell(with: contact)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle the action when a contact cell is selected
        let selectedContact = viewModel.contacts[indexPath.row]
        let contactDetailsVC = ContactDetailsViewController(contact: selectedContact)
        navigationController?.pushViewController(contactDetailsVC, animated: true)
    }
    
    
}
