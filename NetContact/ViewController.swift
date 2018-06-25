//
//  ViewController.swift
//  NetContact
//
//  Created by Luca Colombano on 24/05/18.
//  Copyright © 2018 Aral. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {

    @IBOutlet weak var tableViewContacts: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    
    var contactList = CNContactStore()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.

        self.tabBar.delegate = self
        loadContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableViewContacts.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadContacts() {
        do {
            let req = CNContactFetchRequest(keysToFetch: [
                CNContactIdentifierKey as CNKeyDescriptor,
                CNContactImageDataAvailableKey as CNKeyDescriptor,
                CNContactImageDataKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor,
                CNContactEmailAddressesKey as CNKeyDescriptor,
                CNContactFamilyNameKey as CNKeyDescriptor,
                CNContactGivenNameKey as CNKeyDescriptor
                ])
            req.sortOrder = CNContactSortOrder.familyName
            try contactList.enumerateContacts (with: req) {
                (contact, stop) -> Void in
                let newContact = MyContact()
                newContact.contact = contact
                getUserData(contact.identifier, newContact)
                gContacts.append(newContact)
            }
            
            filterContacts(-1)
        } catch {
            print(error)
        }
    }
    
    func filterContacts(_ filter: Int) {
        if (filter != -1) {
            gContactsForListView = gContacts.filter({contact in contact.relationType == filter})
        } else {
            gContactsForListView = gContacts
        }
    }

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
            case 1:
                filterContacts(4)
            case 2:
                filterContacts(3)
            default:
                filterContacts(-1)
        }

        tableViewContacts.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gContactsForListView.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactsTableViewCell
        
        cell.Contact = gContactsForListView[indexPath.item]
        
        cell.labelName?.text = gContactsForListView[indexPath.item].contact.familyName + " " + gContactsForListView[indexPath.item].contact.givenName
        
        if (gContactsForListView[indexPath.item].contact.imageDataAvailable) {
            cell.buttonContactImage?.layer.cornerRadius = 30
            cell.buttonContactImage?.clipsToBounds = true
            cell.buttonContactImage?.setBackgroundImage(UIImage(data: gContactsForListView[indexPath.item].contact.imageData!), for: UIControlState.normal)
        } else {
            var contactText = ""
            
            if (!gContactsForListView[indexPath.item].contact.familyName.isEmpty) {
                contactText += String(gContactsForListView[indexPath.row].contact.familyName.first!)
            }
            
            if (!gContactsForListView[indexPath.item].contact.givenName.isEmpty) {
                contactText += String(gContactsForListView[indexPath.item].contact.givenName.first!)
            }

            cell.buttonContactImage?.setBackgroundImage(UIImage.circle(diameter: 60, color: UIColor.lightGray, text: contactText as NSString), for: UIControlState.normal)
        }
        
        cell.setRating(gContactsForListView[indexPath.row].rating)
        
        cell.labelContatType?.layer.cornerRadius = 12
        cell.labelContatType?.clipsToBounds = true
        cell.labelContatType?.text = gPickerTypeData[gContactsForListView[indexPath.row].relationType]
        
        return cell
    }
}

class ContactsTableViewCell : UITableViewCell {
    var Contact = MyContact()
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var buttonContactImage: UIButton!
    @IBOutlet weak var buttonRating1: UIButton!
    @IBOutlet weak var buttonRating2: UIButton!
    @IBOutlet weak var buttonRating3: UIButton!
    @IBOutlet weak var buttonRating4: UIButton!
    @IBOutlet weak var labelContatType: UILabel!

/*    @IBAction func Rating1TouchDown(_ sender: UIButton) {
        SetRating(1)
    }
    
    @IBAction func Rating2TouchDown(_ sender: UIButton) {
        SetRating(2)
    }
    
    @IBAction func Rating3TouchDown(_ sender: UIButton) {
        SetRating(3)
    }
    
    @IBAction func Rating4TouchDown(_ sender: UIButton) {
        SetRating(4)
    }*/

    func setRating(_ rating: Int) {
        buttonRating1.setBackgroundImage(rating > 0 ? #imageLiteral(resourceName: "rating_on") : #imageLiteral(resourceName: "rating_off"), for: UIControlState.normal)
        buttonRating2.setBackgroundImage(rating > 1 ? #imageLiteral(resourceName: "rating_on") : #imageLiteral(resourceName: "rating_off"), for: UIControlState.normal)
        buttonRating3.setBackgroundImage(rating > 2 ? #imageLiteral(resourceName: "rating_on") : #imageLiteral(resourceName: "rating_off"), for: UIControlState.normal)
        buttonRating4.setBackgroundImage(rating > 3 ? #imageLiteral(resourceName: "rating_on") : #imageLiteral(resourceName: "rating_off"), for: UIControlState.normal)
    }

    @IBAction func buttonContactImageTouchDown(_ sender: UIButton) {
        gContact = Contact
    }

}

class tabBarController: UITabBarController, UITabBarControllerDelegate {

}
