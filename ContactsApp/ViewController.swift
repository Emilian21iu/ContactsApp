//
//  ViewController.swift
//  ContactsApp
//
//  Created by Lupu Emilian on 24.07.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       navigationItem.title = "Add contact"
       navigationItem.titleView?.backgroundColor = .blue
    }


}

