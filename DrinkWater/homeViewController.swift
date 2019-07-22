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

class homeViewController: UIViewController {

    @IBOutlet weak var sendItButton: UIButton!
    @IBOutlet weak var contactToSendTo: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contactsTableView: UITableView!
    private let contactCellID = "ContactCell"
    private var fetchedContactsList = [CNContact]()
    private var contactList = [CNContact]()
    private var currentContact: CNContact?
    private var recentContactsList = [CNContact]()
    let userDefaults = UserDefaults.standard
    var userName: String?
    
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
        
        if userDefaults.object(forKey: "recentContacts") != nil {
            let decoded  = userDefaults.data(forKey: "recentContacts")
            let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [CNContact]
            recentContactsList = decodedTeams
        }
        
        self.fetchContacts()
        
        self.fetchedContactsList.sort(by: { $0.givenName < $1.givenName })
        self.contactList = recentContactsList + fetchedContactsList
        self.contactsTableView.reloadData()
        
        self.view.backgroundColor = UIColor.init(red: 11/255, green: 112/255, blue: 255/255, alpha: 1)
        self.contactsTableView.backgroundColor = UIColor.clear
        self.titleLabel.textColor = UIColor.white
        self.sendItButton.tintColor = UIColor.white
        self.contactToSendTo.textColor = UIColor.white
        
        self.sendItButton.isEnabled = false
        self.contactToSendTo.isHidden = true
        
        let fullName: String = UIDevice.current.name
        self.userName = String(describing: fullName.split(separator: "’")[0])
        print(userName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reloadData() {
        contactList = recentContactsList + fetchedContactsList
        self.contactsTableView.reloadData()
    }
    
    
    @objc private func sendMessage(contact: CNContact) {
        let Messages = waterMessages()
        manageRecentContacts(contact: contact)
        let message: String
        if self.userName != nil {
            message = "Your Friend, \(self.userName!) wants to remind you to Drink Water, so... \(Messages.messages[Int(arc4random()) % Messages.messages.count])"
        }
        else {
            message = "Your anonymous friend wants to remind you to Drink Water, so... \(Messages.messages[Int(arc4random()) % Messages.messages.count])"
        }

        print (message)
        let accountSID = "AC72ce0e1e8873389e9467edfd9eabd86e"
        
        let _ = Database.database().reference().child("key").observe(.value) { (snapshot) in
            if let value = snapshot.value as? String {
                let authToken = value
                let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
                let parameters = ["From": "+12133194018", "To": "\((contact.phoneNumbers[0].value as! CNPhoneNumber).value(forKey: "digits") as! String)", "Body": message]
                
                Alamofire.request(url, method: .post, parameters: parameters)
                    .authenticate(user: accountSID, password: authToken)
                    .responseJSON { response in
                        debugPrint(response)
                        print("RESPONSE", response)
                }
                
                let reference = Database.database().reference()
                reference.child(UIDevice.current.identifierForVendor!.uuidString).child("Contact").updateChildValues(["Phone Number" : message])
            }
            else {
                return
            }
        }
        reloadData()
    }
    
    func manageRecentContacts(contact: CNContact) {
        recentContactsList.insert(contact, at: 0)
        if recentContactsList.count > 5 {
            recentContactsList.removeLast(1)
        }
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: recentContactsList)
        userDefaults.set(encodedData, forKey: "recentContacts")
        userDefaults.synchronize()
    }
    
    private func fetchContacts() {
        print("Attempting to fetch contacts!")
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if error != nil {
                print ("Error fetching contacts")
                return
            }
            
            let keys: [CNKeyDescriptor] = [CNContactGivenNameKey as CNKeyDescriptor, CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey as CNKeyDescriptor]
            let request = CNContactFetchRequest(keysToFetch: keys)
            
            do {
                try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                    self.fetchedContactsList.append(contact)
                    DispatchQueue.main.async {
                        self.fetchedContactsList.sort(by: { $0.givenName < $1.givenName })
                        self.contactList = self.recentContactsList + self.fetchedContactsList
                        self.contactsTableView.reloadData()
                    }
                })
            } catch let error {
                print ("Failed to enumerate contacts:", error)
            }
        }
    }
    
    func contactChosen(contact: CNContact){
        self.currentContact = contact
        self.sendItButton.isEnabled = true
        self.contactToSendTo.text = contact.givenName
        self.contactToSendTo.isHidden = false
    }
    
    @IBAction func drinkWaterButtonPressed(_ sender: Any) {
        
        if let currentContact = self.currentContact {
            sendMessage(contact: currentContact)
            let alert = UIAlertController(title: "Oh Baby!", message: "You just reminded your friend to drink water!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Uh Oh!", message: "Something went wrong, try again later!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension homeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(contactList.count)
        return contactList.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = contactList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! ContactCell
        if indexPath.row < recentContactsList.count {
            cell.setCell(contact: contact, isRecent: true)
        } else {
            cell.setCell(contact: contact, isRecent: false)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.contactChosen(contact: contactList[indexPath.row])
    }
}

