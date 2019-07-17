//
//  ContactCell.swift
//  DrinkWater
//
//  Created by Justin Rodriguez on 7/3/19.
//  Copyright © 2019 David Ho. All rights reserved.
//

import UIKit
import Contacts

class ContactCell: UITableViewCell {

    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    func setCell(contact: CNContact){
        self.layer.backgroundColor = UIColor.clear.cgColor
        
        test.text = "\(contact.givenName) \(contact.familyName)"
        guard let phoneNumber = contact.phoneNumbers.first?.value.stringValue else {
            return
        }
        captionLabel.text = phoneNumber
    }
}
