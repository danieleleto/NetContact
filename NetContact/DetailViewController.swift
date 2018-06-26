//
//  DetailViewController.swift
//  NetContact
//
//  Created by Luca Colombano on 30/05/18.
//  Copyright © 2018 Aral. All rights reserved.
//

import UIKit
import Contacts
import MessageUI

class DetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageContact: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var buttonRating1: UIButton!
    @IBOutlet weak var buttonRating2: UIButton!
    @IBOutlet weak var buttonRating3: UIButton!
    @IBOutlet weak var buttonRating4: UIButton!
    @IBOutlet weak var buttonType: UIButton!
    @IBOutlet weak var pickerPhoneNumbers: UIPickerView!
    @IBOutlet weak var viewPickerPhoneNumbers: UIView!
    @IBOutlet weak var pickerType: UIPickerView!
    @IBOutlet weak var viewPickerType: UIView!
    @IBOutlet weak var pickerEmails: UIPickerView!
    @IBOutlet weak var viewPickerEmails: UIView!
    @IBOutlet weak var buttonPhoneCall: UIButton!
    @IBOutlet weak var buttonSMS: UIButton!
    @IBOutlet weak var buttonEmail: UIButton!
    @IBOutlet weak var buttonWhatsApp: UIButton!
    
    let contact = gContact
    var selectedType = Int()
    var phoneSMSOrWhatsApp = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesturePhoneCall = UITapGestureRecognizer(target: self, action : #selector(buttonPhoneCallTapGesture(_:)))
        let longGesturePhoneCall = UILongPressGestureRecognizer(target: self, action: #selector(buttonPhoneCallLongTap(_:)))
        let tapGestureSMS = UITapGestureRecognizer(target: self, action : #selector(buttonSMSTapGesture(_:)))
        let longGestureSMS = UILongPressGestureRecognizer(target: self, action: #selector(buttonSMSLongTap(_:)))
        let tapGestureWhatsApp = UITapGestureRecognizer(target: self, action : #selector(buttonWhatsAppTapGesture(_:)))
        let longGestureWhatsApp = UILongPressGestureRecognizer(target: self, action: #selector(buttonWhatsAppLongTap(_:)))
        let tapGestureEmail = UITapGestureRecognizer(target: self, action : #selector(buttonEmailTapGesture(_:)))
        let longGestureEmail = UILongPressGestureRecognizer(target: self, action: #selector(buttonEmailLongTap(_:)))
        
        buttonPhoneCall.addGestureRecognizer(tapGesturePhoneCall)
        buttonPhoneCall.addGestureRecognizer(longGesturePhoneCall)
        buttonSMS.addGestureRecognizer(longGestureSMS)
        buttonSMS.addGestureRecognizer(tapGestureSMS)
        buttonWhatsApp.addGestureRecognizer(tapGestureWhatsApp)
        buttonWhatsApp.addGestureRecognizer(longGestureWhatsApp)
        buttonEmail.addGestureRecognizer(tapGestureEmail)
        buttonEmail.addGestureRecognizer(longGestureEmail)

        pickerType.delegate = self
        pickerType.dataSource = self
        
        pickerPhoneNumbers.delegate = self
        pickerPhoneNumbers.dataSource = self
        
        pickerEmails.delegate = self
        pickerEmails.dataSource = self
        
        // Do any additional setup after loading the view.
        if (contact.contact.imageDataAvailable) {
            imageContact.layer.cornerRadius = 70
            imageContact.clipsToBounds = true
            imageContact.image = UIImage(data: contact.contact.imageData!)
        } else {
            var contactText = ""
            
            if (!contact.contact.familyName.isEmpty) {
                contactText += String(contact.contact.familyName.first!)
            }
            
            if (!contact.contact.givenName.isEmpty) {
                contactText += String(contact.contact.givenName.first!)
            }
            
            imageContact.image = UIImage.circle(diameter: 70, color: UIColor.lightGray, text: contactText as NSString)
        }
        
        SetRating(contact.rating)
        
        buttonType.layer.cornerRadius = 12
        buttonType.setTitle(gPickerTypeData[contact.relationType], for: .normal)

        labelName.text = contact.contact.familyName + " " + contact.contact.givenName
        
        gPickerPhoneNumbersData.removeAll()
        gPickerPhoneNumbersTypeData.removeAll()
        gPickerEmailsData.removeAll()
        for phoneNumber in contact.contact.phoneNumbers {
            gPickerPhoneNumbersTypeData.append(CNLabeledValue<NSString>.localizedString(forLabel: phoneNumber.label!))
            gPickerPhoneNumbersData.append(phoneNumber.value.stringValue)
        }
        for emailAdress in contact.contact.emailAddresses {
            gPickerEmailsData.append(emailAdress.value.description)
        }
        
        if (!contact.defaultPhone.isEmpty || contact.contact.phoneNumbers.count == 1) {
            buttonPhoneCall.setImage(#imageLiteral(resourceName: "phone_call_ok"), for: UIControlState.normal)
        } else if (contact.contact.phoneNumbers.count == 0) {
            buttonPhoneCall.setImage(#imageLiteral(resourceName: "phone_call_notPresent"), for: UIControlState.normal)
        } else {
            buttonPhoneCall.setImage(#imageLiteral(resourceName: "phone_call_notDefault"), for: UIControlState.normal)
        }
        
        if (!contact.defaultSMS.isEmpty || contact.contact.phoneNumbers.count == 1) {
            buttonSMS.setImage(#imageLiteral(resourceName: "send_sms_ok"), for: UIControlState.normal)
        } else if (contact.contact.phoneNumbers.count == 0) {
            buttonSMS.setImage(#imageLiteral(resourceName: "send_sms_notPresent"), for: UIControlState.normal)
        } else {
            buttonSMS.setImage(#imageLiteral(resourceName: "send_sms_notDefault"), for: UIControlState.normal)
        }
        
        if (!contact.defaultWhatsApp.isEmpty || contact.contact.phoneNumbers.count == 1) {
            buttonWhatsApp.setImage(#imageLiteral(resourceName: "send_whatsapp_ok"), for: UIControlState.normal)
        } else if (contact.contact.phoneNumbers.count == 0) {
            buttonWhatsApp.setImage(#imageLiteral(resourceName: "send_whatsapp_notPresent"), for: UIControlState.normal)
        } else {
            buttonWhatsApp.setImage(#imageLiteral(resourceName: "send_whatsapp_notDefault"), for: UIControlState.normal)
        }
        
        if (!contact.defaultEmail.isEmpty || contact.contact.emailAddresses.count == 1) {
            buttonEmail.setImage(#imageLiteral(resourceName: "send_email_ok"), for: UIControlState.normal)
        } else if (contact.contact.emailAddresses.count == 0) {
            buttonEmail.setImage(#imageLiteral(resourceName: "send_email_notPresent"), for: UIControlState.normal)
        } else {
            buttonEmail.setImage(#imageLiteral(resourceName: "send_Email_notDefault"), for: UIControlState.normal)
        }
    }

    @IBAction func Rating1ButtonTouchDown(_ sender: UIButton) {
        SetRating(1)
    }
    
    @IBAction func Rating1ButtonReTouch(_ sender: UIButton) {
        ResetRating(1)
    }
    
    @IBAction func Rating2ButtonTouchDown(_ sender: UIButton) {
        SetRating(2)
    }
    @IBAction func Rating3ButtonTouchDown(_ sender: UIButton) {
        SetRating(3)
    }
    @IBAction func Rating4ButtonTouchDown(_ sender: UIButton) {
        SetRating(4)
    }
    
    func SetRating(_ rating: Int) {
        buttonRating1.setImage(rating > 0 ? #imageLiteral(resourceName: "rating_on") : #imageLiteral(resourceName: "rating_off"), for: UIControlState.normal)
        buttonRating2.setImage(rating > 1 ? #imageLiteral(resourceName: "rating_on") : #imageLiteral(resourceName: "rating_off"), for: UIControlState.normal)
        buttonRating3.setImage(rating > 2 ? #imageLiteral(resourceName: "rating_on") : #imageLiteral(resourceName: "rating_off"), for: UIControlState.normal)
        buttonRating4.setImage(rating > 3 ? #imageLiteral(resourceName: "rating_on") : #imageLiteral(resourceName: "rating_off"), for: UIControlState.normal)
        
        updateRating(contact.contact.identifier, rating)
        contact.rating = rating
    }
    
    func ResetRating(_ rating: Int) {
        let rating = 0
        buttonRating1.setImage(#imageLiteral(resourceName: "rating_off"), for: UIControlState.normal)
        buttonRating2.setImage(#imageLiteral(resourceName: "rating_off"), for: UIControlState.normal)
        buttonRating3.setImage(#imageLiteral(resourceName: "rating_off"), for: UIControlState.normal)
        buttonRating4.setImage(#imageLiteral(resourceName: "rating_off"), for: UIControlState.normal)
        
        updateRating(contact.contact.identifier, rating)
        contact.rating = rating
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func TypeButtonTouchDown(_ sender: UIButton) {
        viewPickerType.isHidden = false
    }
    
    @objc func buttonPhoneCallTapGesture(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            var phoneNumber: String = ""
            
            if (contact.contact.phoneNumbers.count == 1) {
                phoneNumber = contact.contact.phoneNumbers[0].value.stringValue
                phoneNumber.makeACall()
            } else if (!contact.defaultPhone.isEmpty) {
                contact.defaultPhone.makeACall()
            } else {
                phoneSMSOrWhatsApp = 0
                
                if (contact.contact.phoneNumbers.count == 0) {
                    numberNotPresent()
                } else {
                    viewPickerPhoneNumbers.isHidden = false
                }
            }
        }
    }
    
    @objc func buttonPhoneCallLongTap(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            var phoneNumber: String = ""
            
            if (contact.contact.phoneNumbers.count == 1) {
                phoneNumber = contact.contact.phoneNumbers[0].value.stringValue
                phoneNumber.makeACall()
            } else {
                phoneSMSOrWhatsApp = 0
                
                viewPickerPhoneNumbers.isHidden = false
            }
        }
    }
    
    @objc func buttonSMSTapGesture(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            var phoneNumber: String = ""
            
            if (contact.contact.phoneNumbers.count == 1) {
                phoneNumber = contact.contact.phoneNumbers[0].value.stringValue
                phoneNumber.sendSMS()
            } else if (!contact.defaultSMS.isEmpty) {
                contact.defaultSMS.sendSMS()
            } else {
                phoneSMSOrWhatsApp = 1
                
                if (contact.contact.phoneNumbers.count == 0) {
                    numberNotPresent()
                } else {
                    viewPickerPhoneNumbers.isHidden = false
                }
            }
        }
    }
    
    @objc func buttonSMSLongTap(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            var phoneNumber: String = ""
            
            if (contact.contact.phoneNumbers.count == 1) {
                phoneNumber = contact.contact.phoneNumbers[0].value.stringValue
                phoneNumber.sendSMS()
            } else {
                phoneSMSOrWhatsApp = 1
                
                viewPickerPhoneNumbers.isHidden = false
            }
        }
    }
    
    @objc func buttonWhatsAppTapGesture(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            var phoneNumber: String = ""
            
            if (contact.contact.phoneNumbers.count == 1) {
                phoneNumber = contact.contact.phoneNumbers[0].value.stringValue
                phoneNumber.sendWhatsApp()
            } else if (!contact.defaultWhatsApp.isEmpty) {
                contact.defaultWhatsApp.sendWhatsApp()
            } else {
                phoneSMSOrWhatsApp = 2
                
                if (contact.contact.phoneNumbers.count == 0) {
                    numberNotPresent()
                } else {
                    viewPickerPhoneNumbers.isHidden = false
                }
            }
        }
    }
    
    @objc func buttonWhatsAppLongTap(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            var phoneNumber: String = ""
            
            if (contact.contact.phoneNumbers.count == 1) {
                phoneNumber = contact.contact.phoneNumbers[0].value.stringValue
                phoneNumber.sendWhatsApp()
            } else {
                phoneSMSOrWhatsApp = 2
                
                viewPickerPhoneNumbers.isHidden = false
            }
        }
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func buttonEmailTapGesture(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            var email: String = ""
            
            if (contact.contact.emailAddresses.count == 1) {
                email = contact.contact.emailAddresses[0].value.description
                contact.defaultEmail.append(email)
                sendEmail(emailParameter: email)
            } else if (!contact.defaultEmail.isEmpty) {
                sendEmail(emailParameter: contact.defaultEmail)
            } else {
                if (contact.contact.emailAddresses.count == 0) {
                    emailNotPresent()
                } else {
                    viewPickerEmails.isHidden = false
                }
            }
        }
    }
    
    func sendEmail(emailParameter : String) {
        if (MFMailComposeViewController.canSendMail()) {
            let composePicker = MFMailComposeViewController()
            composePicker.mailComposeDelegate = self
            self.present(composePicker, animated: true, completion: nil)
            composePicker.setToRecipients([emailParameter])
            composePicker.setSubject("Nuovo messaggio")
            composePicker.setMessageBody("Questa è un email di prova, ciao", isHTML: false)
        } else {
            self.showErrorMessage()
        }
    }
    
    @objc func buttonEmailLongTap(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            var email: String = ""
            
            if (contact.contact.emailAddresses.count == 1) {
                email = contact.contact.emailAddresses[0].value.description
                sendEmail(emailParameter: email)
            } else {
                if (contact.contact.emailAddresses.count == 0) {
                    emailNotPresent()
                } else {
                    viewPickerEmails.isHidden = false
                }
            }
        }
    }
    
    func emailNotPresent() {
        let alertMessage = UIAlertController(title: "Il contatto non ha un indirizzo email", message: "Si prega di aggiungerne uno!", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title:"Okay", style: UIAlertActionStyle.default, handler: nil)
        alertMessage.addAction(action)
        self.present(alertMessage, animated: true, completion: nil)
    }
    
    func showErrorMessage() {
        let alertMessage = UIAlertController(title: "could not sent email", message: "check if your device have email support!", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title:"Okay", style: UIAlertActionStyle.default, handler: nil)
        alertMessage.addAction(action)
        self.present(alertMessage, animated: true, completion: nil)
    }
    
    func numberNotPresent() {
        let alertMessage = UIAlertController(title: "Il contatto non ha un numero di telefono", message: "Si prega di aggiungerne uno!", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title:"Okay", style: UIAlertActionStyle.default, handler: nil)
        alertMessage.addAction(action)
        self.present(alertMessage, animated: true, completion: nil)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return gPickerTypeData.count
        } else if(pickerView.tag == 2) {
            return gPickerPhoneNumbersData.count
        } else {
            return gPickerEmailsData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1) {
            return gPickerTypeData[row].description
        } else if (pickerView.tag == 2) {
            return gPickerPhoneNumbersTypeData[row].description + " - " + gPickerPhoneNumbersData[row].description
        } else {
            return gPickerEmailsData[row].description
        }
    }
    
    @IBAction func buttonPickerTypeDone(_ sender: UIBarButtonItem) {
        buttonType.setTitle(gPickerTypeData[pickerType.selectedRow(inComponent: 0)].description, for: .normal)
        updateType(contact.contact.identifier, pickerType.selectedRow(inComponent: 0))
        contact.relationType = pickerType.selectedRow(inComponent: 0)

        viewPickerType.isHidden = true
    }
    
    @IBAction func buttonPickerNumbersDone(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Numero predefinito", message: "Utilizzare il numero selezionato come predefinito?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        let yesAction = UIAlertAction(title: "Si", style: .default, handler: { (action) -> Void in
            switch self.phoneSMSOrWhatsApp {
            case 0:
                updateDefaultPhoneNumber(self.contact.contact.identifier, gPickerPhoneNumbersData[self.pickerPhoneNumbers.selectedRow(inComponent: 0)].description)
                
                self.contact.defaultPhone = gPickerPhoneNumbersData[self.pickerPhoneNumbers.selectedRow(inComponent: 0)].description
                
                self.buttonPhoneCall.setImage(#imageLiteral(resourceName: "phone_call_ok"), for: UIControlState.normal)
            case 1:
                updateDefaultSMSNumber(self.contact.contact.identifier, gPickerPhoneNumbersData[self.pickerPhoneNumbers.selectedRow(inComponent: 0)].description)
                
                self.contact.defaultSMS = gPickerPhoneNumbersData[self.pickerPhoneNumbers.selectedRow(inComponent: 0)].description
                
                self.buttonSMS.setImage(#imageLiteral(resourceName: "send_sms_ok"), for: UIControlState.normal)
            case 2:
                updateDefaultWhatsAppNumber(self.contact.contact.identifier, gPickerPhoneNumbersData[self.pickerPhoneNumbers.selectedRow(inComponent: 0)].description)
                
                self.contact.defaultWhatsApp = gPickerPhoneNumbersData[self.pickerPhoneNumbers.selectedRow(inComponent: 0)].description
                
                self.buttonWhatsApp.setImage(#imageLiteral(resourceName: "send_whatsapp_ok"), for: UIControlState.normal)
            default: break
            }
            self.alertViewPhoneSMSOrWhatsApp(alertView: alert)
        })
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: { (action) -> Void in
            self.alertViewPhoneSMSOrWhatsApp(alertView: alert)
        })
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        viewPickerPhoneNumbers.isHidden = true
        
    }
    
    func alertViewPhoneSMSOrWhatsApp(alertView: UIAlertController!){
        switch self.phoneSMSOrWhatsApp {
        case 0:
            gPickerPhoneNumbersData[self.pickerPhoneNumbers.selectedRow(inComponent: 0)].description.makeACall()
        case 1:
            gPickerPhoneNumbersData[self.pickerPhoneNumbers.selectedRow(inComponent: 0)].description.sendSMS()
        case 2:
            gPickerPhoneNumbersData[self.pickerPhoneNumbers.selectedRow(inComponent: 0)].description.sendWhatsApp()
        default: break;
        }
    }
    
    @IBAction func buttonPickerEmailsDone(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Email predefinita", message: "Utilizzare l'email selezionata come predefinita?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        let yesAction = UIAlertAction(title: "Si", style: .default, handler: { (action) -> Void in
            updateDefaultEmail(self.contact.contact.identifier, gPickerEmailsData[self.pickerEmails.selectedRow(inComponent: 0)].description)
            self.contact.defaultEmail = gPickerEmailsData[self.pickerEmails.selectedRow(inComponent: 0)].description
            self.sendEmail(emailParameter: getDefaultEmail(self.contact.contact.identifier))
            
            self.buttonEmail.setImage(#imageLiteral(resourceName: "send_email_ok"), for: UIControlState.normal)
        })
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: { (action) -> Void in
            self.sendEmail(emailParameter : gPickerEmailsData[self.pickerEmails.selectedRow(inComponent: 0)].description)
        })
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        viewPickerEmails.isHidden = true
    }
    
    @IBAction func buttonPickerTypeCancel(_ sender: UIBarButtonItem) {
        viewPickerType.isHidden = true
    }
    
    @IBAction func buttonPickerNumbersCancel(_ sender: UIBarButtonItem) {
        viewPickerPhoneNumbers.isHidden = true
    }
    
    @IBAction func buttonPickerEmailsCancel(_ sender: UIBarButtonItem) {
        viewPickerEmails.isHidden = true
    }
    
}
