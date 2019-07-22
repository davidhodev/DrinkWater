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
    @IBOutlet weak var thirstyMessageLabel: UILabel!
    
    let thirstyMessages = ["Hella Thirsty", "Well Hydrated", "Drowning", "Has a Hydro", "Dehydrated", "Crazy Dehydrated", "Needs water ASAP", "Thirsty"]
    
    func setCell(contact: CNContact, isRecent: Bool){
        self.layer.backgroundColor = UIColor.clear.cgColor
        
        if isRecent {
            thirstyMessageLabel.text = "🍼 " + thirstyMessages[Int.random(in: 0 ... 7)]
        } else {
            thirstyMessageLabel.text = thirstyMessages[Int.random(in: 0 ... 7)]
        }
        test.text = "\(contact.givenName) \(contact.familyName)"
        guard let phoneNumber = contact.phoneNumbers.first?.value.stringValue else {
            return
        }
        captionLabel.text = phoneNumber
    }
}
