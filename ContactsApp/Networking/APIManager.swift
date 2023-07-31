//
//  APIManager.swift
//  ContactsApp
//
//  Created by Lupu Emilian on 25.07.2023.
//

import Foundation
import UIKit


class APIManager {
    
    //Singleton instance of APIManager
    static let shared = APIManager()
    private init(){}
    
//    private let baseURL = URL(string: "https://gorest.co.in/public/v2/users")!
    
    
    //the base URL for fetching contacts data from the API
    private let baseURL = URL(string: "https://mocki.io/v1/2a478069-bd4a-4138-8e9a-eef5a54ed33a")!
    
    
    //fetch contacts data from the API
    func fetchContacts(completion: @escaping ([Contacts]?) -> Void) {
        URLSession.shared.dataTask(with: baseURL) {
            data, _, error in
            //Check for errors during API request
            guard let data =  data, error == nil else {
                print("Api error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
//                let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                print(results)
                
        //Decode the JSON data into ContactsResponse object using JSONDecoder
                let decoder = JSONDecoder()
                let contactResponse = try decoder.decode(ContactsResponse.self, from: data)
                let activeContacts = contactResponse.data.filter {$0.isActive}
               // print(activeContacts)
       //Filter only active contacts and pass them to the completion hanlder
                //completion(activeContacts)
            }catch {
                print("JSON decoding error: \(error.localizedDescription)")
                completion(nil)
            }
            
        }.resume()
    }
    
    //Fetch users data from a different API endpoint
    func fetchUsersFromAPI(completion: @escaping ([User]) -> Void) {
        let urlString = "https://gorest.co.in/public/v2/users"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            if let error = error {
                print("Error: \(error)")
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do{
                //Decode the JSON data into an array of User objects using JSONDecoder
                let decoder = JSONDecoder()
                let users = try decoder.decode([User].self, from: data)
               // print("Response: \(users)")
                completion(users)
            }catch {
                print("Error decoding API response: \(error)")
            }
        }
        task.resume()
    }
    
    //Cache the fetched users locally using UserDefaults
    func cacheUsersLocally(users: [User]){
        do{
            let encoder = JSONEncoder()
            let data = try encoder.encode(users)
            UserDefaults.standard.set(data, forKey: "cacheUsers")
        }catch {
            print("Error caching users: \(error)")
        }
    }
    
}


