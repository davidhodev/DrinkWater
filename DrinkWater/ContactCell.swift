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
    
    
    func setCell(contact: CNContact){
        print("cool")
        print(contact.givenName)
        test.text = contact.givenName
    }
}
