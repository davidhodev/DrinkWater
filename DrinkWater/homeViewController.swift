//
//  ViewController.swift
//  DrinkWater
//
//  Created by David Ho on 6/29/19.
//  Copyright © 2019 David Ho. All rights reserved.
//

import UIKit
import Foundation
import Contacts
import MessageUI
import FirebaseDatabase
import Alamofire

class homeViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var sendItButton: UIButton!
    @IBOutlet weak var contactToSendTo: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contactsTableView: UITableView!
    private let contactCellID = "ContactCell"
    
    private var contactList = [CNContact]()
    
    init(){
        super.init(nibName: "homeViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsTableView.register(UINib.init(nibName: contactCellID, bundle: nil), forCellReuseIdentifier: contactCellID)
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        contactsTableView.rowHeight = UITableViewAutomaticDimension
        contactsTableView.separatorColor = UIColor.clear
        
        self.fetchContacts()
        
        self.view.backgroundColor = UIColor.init(red: 11/255, green: 112/255, blue: 255/255, alpha: 1)
        self.contactsTableView.backgroundColor = UIColor.clear
        self.titleLabel.textColor = UIColor.white
        self.sendItButton.tintColor = UIColor.white
        self.contactToSendTo.textColor = UIColor.white
        
        self.sendItButton.isEnabled = true
        self.contactToSendTo.isHidden = true
        
        contactsTableView.reloadData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        sendMessage()
    }
    
    @objc private func sendMessage() {
        let Messages = waterMessages()
        let message = Messages.messages[Int(arc4random()) % Messages.messages.count]
        
        print (message)
        
        let accountSID = "AC72ce0e1e8873389e9467edfd9eabd86e"
        let authToken = "515e1ee53415c2619f8f2290c92d9ba8"
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
        let parameters = ["From": "+12133194018", "To": "+12136055210", "Body": "Drink Water Slut test!"]
            
        Alamofire.request(url, method: .post, parameters: parameters)
            .authenticate(user: accountSID, password: authToken)
            .responseJSON { response in
                debugPrint(response)
                print("RESPONSE", response)
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

//    @IBAction func drinkWaterButtonPressed(_ sender: Any) {
//        print("Pressed")
//        sendMessage()
//    }
//
//    @IBAction func settingsButtonPressed(_ sender: Any) {
//        print("Settings")
//    }
    
    
    
}

extension homeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(contactList.count)
        return contactList.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = contactList[indexPath.row]
        print(contact.givenName)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! ContactCell
        cell.setCell(contact: contact)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

