//
//  ViewController.swift
//  NetContact
//
//  Created by Luca Colombano on 24/05/18.
//  Copyright © 2018 Aral. All rights reserved.
//

import UIKit
import Contacts
import MessageUI

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
        
        cell.labelName.text = gContactsForListView[indexPath.item].contact.familyName + " " + gContactsForListView[indexPath.item].contact.givenName
        
        if (gContactsForListView[indexPath.item].contact.imageDataAvailable) {
            cell.buttonContactImage.layer.cornerRadius = 30
            cell.buttonContactImage.clipsToBounds = true
            cell.buttonContactImage.setBackgroundImage(UIImage(data: gContactsForListView[indexPath.item].contact.imageData!), for: UIControlState.normal)
        } else {
            var contactText = ""
            
            if (!gContactsForListView[indexPath.item].contact.familyName.isEmpty) {
                contactText += String(gContactsForListView[indexPath.row].contact.familyName.first!)
            }
            
            if (!gContactsForListView[indexPath.item].contact.givenName.isEmpty) {
                contactText += String(gContactsForListView[indexPath.item].contact.givenName.first!)
            }

            cell.buttonContactImage.setBackgroundImage(UIImage.circle(diameter: 60, color: UIColor.lightGray, text: contactText as NSString), for: UIControlState.normal)
        }
        
        cell.setRating(gContactsForListView[indexPath.row].rating)
        
        cell.labelContatType.layer.cornerRadius = 12
        cell.labelContatType.clipsToBounds = true
        cell.labelContatType.text = gPickerTypeData[gContactsForListView[indexPath.row].relationType]
        
        if (!cell.Contact.defaultPhone.isEmpty || cell.Contact.contact.phoneNumbers.count == 1) {
            cell.buttonPhoneCall.setImage(#imageLiteral(resourceName: "phone_call_ok"), for: UIControlState.normal)
        } else if (cell.Contact.contact.phoneNumbers.count == 0) {
            cell.buttonPhoneCall.setImage(#imageLiteral(resourceName: "phone_call_notPresent"), for: UIControlState.normal)
        } else {
            cell.buttonPhoneCall.setImage(#imageLiteral(resourceName: "phone_call_notDefault"), for: UIControlState.normal)
        }
        
        if (!cell.Contact.defaultSMS.isEmpty || cell.Contact.contact.phoneNumbers.count == 1) {
            cell.buttonSMS.setImage(#imageLiteral(resourceName: "send_sms_ok"), for: UIControlState.normal)
        } else if (cell.Contact.contact.phoneNumbers.count == 0) {
            cell.buttonSMS.setImage(#imageLiteral(resourceName: "send_sms_notPresent"), for: UIControlState.normal)
        } else {
            cell.buttonSMS.setImage(#imageLiteral(resourceName: "send_sms_notDefault"), for: UIControlState.normal)
        }
        
        if (!cell.Contact.defaultWhatsApp.isEmpty || cell.Contact.contact.phoneNumbers.count == 1) {
            cell.buttonWhatsApp.setImage(#imageLiteral(resourceName: "send_whatsapp_ok"), for: UIControlState.normal)
        } else if (cell.Contact.contact.phoneNumbers.count == 0) {
            cell.buttonWhatsApp.setImage(#imageLiteral(resourceName: "send_whatsapp_notPresent"), for: UIControlState.normal)
        } else {
            cell.buttonWhatsApp.setImage(#imageLiteral(resourceName: "send_whatsapp_notDefault"), for: UIControlState.normal)
        }
        
        if (!cell.Contact.defaultEmail.isEmpty || cell.Contact.contact.emailAddresses.count == 1) {
            cell.buttonEmail.setImage(#imageLiteral(resourceName: "send_email_ok"), for: UIControlState.normal)
        } else if (cell.Contact.contact.emailAddresses.count == 0) {
            cell.buttonEmail.setImage(#imageLiteral(resourceName: "send_email_notPresent"), for: UIControlState.normal)
        } else {
            cell.buttonEmail.setImage(#imageLiteral(resourceName: "send_Email_notDefault"), for: UIControlState.normal)
        }
        
        return cell
    }
}

class ContactsTableViewCell : UITableViewCell, MFMailComposeViewControllerDelegate {
    var Contact = MyContact()
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var buttonContactImage: UIButton!
    @IBOutlet weak var buttonRating1: UIButton!
    @IBOutlet weak var buttonRating2: UIButton!
    @IBOutlet weak var buttonRating3: UIButton!
    @IBOutlet weak var buttonRating4: UIButton!
    @IBOutlet weak var labelContatType: UILabel!
    @IBOutlet weak var buttonPhoneCall: UIButton!
    @IBOutlet weak var buttonSMS: UIButton!
    @IBOutlet weak var buttonEmail: UIButton!
    @IBOutlet weak var buttonWhatsApp: UIButton!
    
    func setRating(_ rating: Int) {
        buttonRating1.setImage(rating > 0 ? #imageLiteral(resourceName: "rating_on") : #imageLiteral(resourceName: "rating_off"), for: UIControlState.normal)
        buttonRating2.setImage(rating > 1 ? #imageLiteral(resourceName: "rating_on") : #imageLiteral(resourceName: "rating_off"), for: UIControlState.normal)
        buttonRating3.setImage(rating > 2 ? #imageLiteral(resourceName: "rating_on") : #imageLiteral(resourceName: "rating_off"), for: UIControlState.normal)
        buttonRating4.setImage(rating > 3 ? #imageLiteral(resourceName: "rating_on") : #imageLiteral(resourceName: "rating_off"), for: UIControlState.normal)
    }
    
    @IBAction func buttonContactImageTouchDown(_ sender: UIButton) {
        gContact = Contact
    }
    
    @IBAction func buttonPhoneCallTouchDown(_ sender: UIButton) {
        var phoneNumber: String = ""
        
        if (!Contact.defaultPhone.isEmpty || Contact.contact.phoneNumbers.count == 1) {
            phoneNumber = Contact.contact.phoneNumbers[0].value.stringValue
            phoneNumber.makeACall()
        } else if (Contact.contact.phoneNumbers.count == 0) {
            numberNotPresent()
        } else {
            setContactAlert()
        }
    }
    
    @IBAction func buttonSMSTouchDown(_ sender: UIButton) {
        var phoneNumber: String = ""
        
        if (!Contact.defaultSMS.isEmpty || Contact.contact.phoneNumbers.count == 1) {
            phoneNumber = Contact.contact.phoneNumbers[0].value.stringValue
            phoneNumber.sendSMS()
        } else if (Contact.contact.phoneNumbers.count == 0) {
            numberNotPresent()
        } else {
            setContactAlert()
        }
    }
    
    @IBAction func buttonWhatsAppTouchDown(_ sender: UIButton) {
        var phoneNumber: String = ""
        
        if (!Contact.defaultWhatsApp.isEmpty || Contact.contact.phoneNumbers.count == 1) {
            phoneNumber = Contact.contact.phoneNumbers[0].value.stringValue
            phoneNumber.sendWhatsApp()
        } else if (Contact.contact.phoneNumbers.count == 0) {
            numberNotPresent()
        } else {
            setContactAlert()
        }
    }
    
    @IBAction func buttonEmailTouchDown(_ sender: UIButton) {
        var email: String = ""
        
        if (!Contact.defaultEmail.isEmpty || Contact.contact.emailAddresses.count == 1) {
            email = Contact.contact.emailAddresses[0].value.description
            Contact.defaultEmail.append(email)
            sendEmail(emailParameter: email)
        } else if (Contact.contact.emailAddresses.count == 0) {
            emailNotPresent()
        } else {
            setContactAlert()
        }
    }
    
    func sendEmail(emailParameter : String) {
        if (MFMailComposeViewController.canSendMail()) {
            let composePicker = MFMailComposeViewController()
            composePicker.mailComposeDelegate = self
            UIApplication.shared.keyWindow?.rootViewController?.present(composePicker, animated: true, completion: nil)
            composePicker.setToRecipients([emailParameter])
            composePicker.setSubject("Nuovo messaggio")
            composePicker.setMessageBody("Questa è un email di prova, ciao", isHTML: false)
        } else {
            showErrorMessage()
        }
    }
    
    func showErrorMessage() {
        let alertMessage = UIAlertController(title: "could not sent email", message: "check if your device have email support!", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title:"Okay", style: UIAlertActionStyle.default, handler: nil)
        alertMessage.addAction(action)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertMessage, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error:Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
            break
        case .saved:
            print("Mail saved")
            break
        case .sent:
            print("Mail sent")
            break
        case .failed:
            break
        }
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func setContactAlert() {
        let alertMessage = UIAlertController(title: "Entra nel dettaglio", message: "Clicca sulla foto del contatto per selezionare il predefinito", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title:"Okay", style: UIAlertActionStyle.default, handler: nil)
        alertMessage.addAction(action)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertMessage, animated: true, completion: nil)
    }
    
    func numberNotPresent() {
        let alertMessage = UIAlertController(title: "Il contatto non ha un numero di telefono", message: "Si prega di aggiungerne uno!", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title:"Okay", style: UIAlertActionStyle.default, handler: nil)
        alertMessage.addAction(action)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertMessage, animated: true, completion: nil)
    }
    
    func emailNotPresent() {
        let alertMessage = UIAlertController(title: "Il contatto non ha un indirizzo email", message: "Si prega di aggiungerne uno!", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title:"Okay", style: UIAlertActionStyle.default, handler: nil)
        alertMessage.addAction(action)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertMessage, animated: true, completion: nil)
    }
}


class tabBarController: UITabBarController, UITabBarControllerDelegate {

}
