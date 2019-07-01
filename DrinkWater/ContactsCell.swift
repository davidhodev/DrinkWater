//
//  ContactsCell.swift
//  DrinkWater
//
//  Created by Justin Rodriguez on 6/29/19.
//  Copyright © 2019 David Ho. All rights reserved.
//

import UIKit

class ContactsCell: UITableViewCell {
    
    @IBOutlet weak var contactNameLabel: UILabel!
    
    init(contactNameLabel: String) {
        self.contactNameLabel.text = contactNameLabel
    }

    required init?(coder aDecoder: NSCoder) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
