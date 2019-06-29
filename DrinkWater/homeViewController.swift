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
import FirebaseDatabase
import Alamofire

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
        self.view.backgroundColor = UIColor.white
        self.titleLabel.textColor = UIColor.init(red: 11/255, green: 112/255, blue: 255/255, alpha: 1)
        self.sendItButton.tintColor = UIColor.init(red: 11/255, green: 112/255, blue: 255/255, alpha: 1)
        self.contactToSendTo.textColor = UIColor.init(red: 11/255, green: 112/255, blue: 255/255, alpha: 1)
        
        self.sendItButton.isEnabled = false
        self.contactToSendTo.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        sendMessage()
    }
    
    private func sendMessage() {
        let Messages = waterMessages()
        let message = Messages.messages[Int(arc4random()) % Messages.messages.count]
        
        print (message)
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let parameters: Parameters = [
            "To": "2136055210", // Number
            "Body": "Drink Water Slut" // Sdrink
        ]
        
        Alamofire.request("https://gainsboro-whale-7737.twil.io/send", method: .post, parameters: parameters, headers: headers).response { response in
            print(response)
        }

        
        
        let reference = Database.database().reference()
        reference.child(UIDevice.current.identifierForVendor!.uuidString).child("Contact").updateChildValues(["Phone Number" : message])
        
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
    
    class ContactCell : UITableViewCell {
        
    }
    
}

