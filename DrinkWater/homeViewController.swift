//
//  ViewController.swift
//  DrinkWater
//
//  Created by David Ho on 6/29/19.
//  Copyright © 2019 David Ho. All rights reserved.
//

import UIKit
import Contacts
import MessageUI

class homeViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var sendItButton: UIButton!
    @IBOutlet weak var contactToSendTo: UILabel!
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    private var contactList = [CNContact]()
    
    init(){
        super.init(nibName: "homeViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchContacts()
        self.view.backgroundColor = UIColor.init(red: 11/255, green: 112/255, blue: 255/255, alpha: 1)
        self.titleLabel.textColor = UIColor.white
        self.sendItButton.tintColor = UIColor.white
        self.contactToSendTo.textColor = UIColor.white
        self.contactsTableView.backgroundColor = UIColor.init(red: 11/255, green: 112/255, blue: 255/255, alpha: 1)
        
        self.sendItButton.isEnabled = false
        self.contactToSendTo.isHidden = true
        
        for index in 1...contactList.count {
            contactsTableView.cellForRow(at: index) = Co
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        sendMessage()
    }
    
    func sendMessage() {
        let Messages = waterMessages()
        let message = Messages.messages[Int(arc4random()) % Messages.messages.count]
        print (message)
//        let messageViewController = MFMessageComposeViewController()
//        messageViewController.messageComposeDelegate = self
//
//        // Configure the fields of the interface.
//        messageViewController.recipients = ["2136055210"]
//        messageViewController.body = "Drink Water you Slut!"
//
//        // Present the view controller modally.
//        if MFMessageComposeViewController.canSendText() {
//            self.present(messageViewController, animated: true, completion: nil)
//        } else {
//            print("Can't send messages.")
//        }
    }
    
    
    private func fetchContacts() {
        print("Attempting to fetch contacts!")
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if error != nil {
                print ("Error fetching contacts")
                return
            }
            
            let keys: [CNKeyDescriptor] = [CNContactGivenNameKey as CNKeyDescriptor]
            let request = CNContactFetchRequest(keysToFetch: keys)
            
            do {
                try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                    self.contactList.append(contact)
                })
            } catch let error {
                print ("Failed to enumerate contacts:", error)
            }
        }
    }

    @IBAction func drinkWaterButtonPressed(_ sender: Any) {
        print("Pressed")
        sendMessage()
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        print("Settings")
    }
    
    private class ContactCell: NSObject {
        
        let viewController: ContactCell
        let model: CNContact
        
        init(model: CNContact, viewController: ContactCell) {
            self.model = model
            self.viewController = viewController
            super.init()
        }
        
        override func cellClasses() -> [AnyClass] {
            return [
                ContactCell.self
            ]
        }
        override func cellNibNames() -> [String] {
            return [
                "ContactCell",
            ]
        }
        
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return Int(model.slotCount(forPlayerSection: UInt(playerSectionIndex)))
        }
        
        override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return 70.0
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FSBestBallPlayerCell.defaultIdentifier, for: indexPath) as? FSBestBallPlayerCell else {
                return FSTableViewCell.nilCell()
            }
            //            cell.layer.borderWidth = 8
            //            cell.layer.cornerRadius = 8
            //            cell.clipsToBounds = true
            cell.backgroundColor = UIColor.clear
            cell.model = model.slot(at: IndexPath(item: indexPath.row, section: playerSectionIndex))
            cell.reloadData()
            return cell
        }
        
    }
    
}

