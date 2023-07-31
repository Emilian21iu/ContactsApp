//
//  ContactTableViewCell.swift
//  ContactsApp
//
//  Created by Lupu Emilian on 24.07.2023.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    
    //UI Elements
    var nameLabel: UILabel!
    var logoImageView: UIImageView!
    var imageDownloadTask: URLSessionDataTask?
    var arrowIcon: UIImageView!


    // Initialize the cell with its UI elemtns
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //Label to diplay the contact's name
        nameLabel = UILabel(frame: CGRect(x: 100, y: 10, width: 200, height: 30))
        contentView.addSubview(nameLabel)
        
        //ImageView to display the contact's logo or initials
        logoImageView = UIImageView(frame: CGRect(x: 40, y: 2, width: 40, height: 40))
        logoImageView.contentMode = .scaleAspectFit
        contentView.addSubview(logoImageView)
        
       //IMageView to display an arrow icon
        arrowIcon = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrowIcon.tintColor = .gray
        arrowIcon.frame = CGRect(x: 350, y: 12, width: 20, height: 20)
        contentView.addSubview(arrowIcon)
    
        
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been impemented")
    }
    
    
    //Configure the cell with the provided contact data
    func configureCell(with contact: ContactModel) {
        nameLabel.text = "\(contact.firstName )  \(contact.lastName )"
        
        //Load the user's image if id is odd
        if  contact.id % 2 == 0 {
                logoImageView.image = generatedInitialsImage(name: "\(contact.firstName.first!) \(contact.lastName.first!)")
               // print("User id: \(contact.id)")
            }else {
                
                downloadImage(from: URL(string: "https://i.pravatar.cc/300")!)
            }
        
    }
    
    //Function to generate initals image
    func generatedInitialsImage(name: String) -> UIImage {
        let imageSize = CGSize(width: 40, height: 40)
        let imageFrame = CGRect(origin: .zero, size: imageSize)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        //Set the circle background color
        UIColor.gray.setFill()
        context?.fillEllipse(in: imageFrame)
        
        //Draw the initials in white color
        let font = UIFont.systemFont(ofSize: 15)
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let initials = name.split(separator: " ").reduce("") { (result, word) -> String in
            if let firstLetter = word.first {
                return result + String(firstLetter)
            }
            return result
        }
        let textSize = initials.size(withAttributes: attributes)
        
        let textOrigin = CGPoint(x: (imageSize.width - textSize.width) / 2.0, y: (imageSize.height - textSize.height) / 2.0)
        
        initials.draw(at: textOrigin, withAttributes: attributes)

        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return  image ?? UIImage()
    }
    
    //function to download image from URL
    func downloadImage(from url: URL) {
        imageDownloadTask?.cancel()
        imageDownloadTask = URLSession.shared.dataTask(with: url) {
            [weak self] (data, response, error) in
            guard let data = data, error == nil else {
           return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    let circularImage = self?.circularImage(image)
                    self?.logoImageView.image = circularImage
              
                }else {
                    self?.logoImageView.image = UIImage(named: "placeholder")
                }
            }
        }
        imageDownloadTask?.resume()
    }
    
    
    
    //function to convert a given image into a circular image
    func circularImage(_ image: UIImage) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
    
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        
        
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, 0.0)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let circularImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return circularImage
        
    }
    
    

}


