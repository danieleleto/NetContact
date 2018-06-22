//
//  DetailViewController.swift
//  NetContact
//
//  Created by Luca Colombano on 30/05/18.
//  Copyright © 2018 Aral. All rights reserved.
//

import UIKit
import Contacts

class DetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var imageContact: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var buttonRating1: UIButton!
    @IBOutlet weak var buttonRating2: UIButton!
    @IBOutlet weak var buttonRating3: UIButton!
    @IBOutlet weak var buttonRating4: UIButton!
    @IBOutlet weak var buttonType: UIButton!
    @IBOutlet weak var pickerPhoneNumbers: UIPickerView!
    @IBOutlet weak var viewPickerType: UIView!
    @IBOutlet weak var pickerType: UIPickerView!
    @IBOutlet weak var viewPickerPhoneNumbers: UIView!
    @IBOutlet weak var buttonPhoneCall: UIButton!
    @IBOutlet weak var buttonSMS: UIButton!
    @IBOutlet weak var buttonEmail: UIButton!
    @IBOutlet weak var buttonWhatsApp: UIButton!
    
    let contact = gContacts[gContactIdx]
    var selectedType = Int()
    var phoneSMSOrWhatsApp = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let longGestureEMail = UILongPressGestureRecognizer(target: self, action: #selector(buttonEMailLongTap(_:)))
        let longGesturePhoneCall = UILongPressGestureRecognizer(target: self, action: #selector(buttonPhoneCallLongTap(_:)))
        let longGestureSMS = UILongPressGestureRecognizer(target: self, action: #selector(buttonSMSLongTap(_:)))
        let longGestureWhatsApp = UILongPressGestureRecognizer(target: self, action: #selector(buttonWhatsAppLongTap(_:)))
        buttonEmail.addGestureRecognizer(longGestureEMail)
        buttonPhoneCall.addGestureRecognizer(longGesturePhoneCall)
        buttonSMS.addGestureRecognizer(longGestureSMS)
        buttonWhatsApp.addGestureRecognizer(longGestureWhatsApp)

        pickerType.delegate = self
        pickerType.dataSource = self
        
        pickerPhoneNumbers.delegate = self
        pickerPhoneNumbers.dataSource = self
        
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
        for phoneNumber in contact.contact.phoneNumbers {
            gPickerPhoneNumbersTypeData.append(CNLabeledValue<NSString>.localizedString(forLabel: phoneNumber.label!))
            gPickerPhoneNumbersData.append(phoneNumber.value.stringValue)
        }
    }

    @IBAction func Rating1ButtonTouchDown(_ sender: UIButton) {
        SetRating(1)
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
        buttonRating1.setBackgroundImage(rating > 0 ? #imageLiteral(resourceName: "rating_on") : #imageLiteral(resourceName: "rating_off"), for: UIControlState.normal)
        buttonRating2.setBackgroundImage(rating > 1 ? #imageLiteral(resourceName: "rating_on") : #imageLiteral(resourceName: "rating_off"), for: UIControlState.normal)
        buttonRating3.setBackgroundImage(rating > 2 ? #imageLiteral(resourceName: "rating_on") : #imageLiteral(resourceName: "rating_off"), for: UIControlState.normal)
        buttonRating4.setBackgroundImage(rating > 3 ? #imageLiteral(resourceName: "rating_on") : #imageLiteral(resourceName: "rating_off"), for: UIControlState.normal)
        
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
    
    @objc func buttonEMailLongTap(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            var phoneNumber: String = ""
            
            if (contact.contact.phoneNumbers.count == 1) {
                phoneNumber = contact.contact.phoneNumbers[0].value.stringValue
                phoneNumber.sendSMS()
            } else {
                viewPickerPhoneNumbers.isHidden = false
            }
        }
    }

    @IBAction func buttonPhoneCallTouchDown(_ sender: UIButton) {
        var phoneNumber: String = ""
        
        if (contact.contact.phoneNumbers.count == 1) {
            phoneNumber = contact.contact.phoneNumbers[0].value.stringValue
            phoneNumber.makeACall()
        } else if (!contact.defaultPhone.isEmpty) {
            contact.defaultPhone.makeACall()
        } else {
            phoneSMSOrWhatsApp = 0
            
            viewPickerPhoneNumbers.isHidden = false
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
    
    @IBAction func buttonSMSTouchDown(_ sender: UIButton) {
        var phoneNumber: String = ""
        
        if (contact.contact.phoneNumbers.count == 1) {
            phoneNumber = contact.contact.phoneNumbers[0].value.stringValue
            phoneNumber.sendSMS()
        } else if (!contact.defaultSMS.isEmpty) {
            contact.defaultSMS.sendSMS()
        } else {
            phoneSMSOrWhatsApp = 1
            
            viewPickerPhoneNumbers.isHidden = false
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

    @objc func buttonWhatsAppLongTap(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            var phoneNumber: String = ""
            
            if (contact.contact.phoneNumbers.count == 1) {
                phoneNumber = contact.contact.phoneNumbers[0].value.stringValue
                phoneNumber.sendSMS()
            } else {
                phoneSMSOrWhatsApp = 2
                
                viewPickerPhoneNumbers.isHidden = false
            }
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return gPickerTypeData.count
        } else {
            return gPickerPhoneNumbersData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1) {
            return gPickerTypeData[row].description
        } else {
            return gPickerPhoneNumbersTypeData[row].description + " - " + gPickerPhoneNumbersData[row].description
        }
    }
    
    @IBAction func buttonPickerTypeDone(_ sender: UIBarButtonItem) {
        buttonType.setTitle(gPickerTypeData[pickerType.selectedRow(inComponent: 0)].description, for: .normal)
        
        updateType(contact.contact.identifier, pickerType.selectedRow(inComponent: 0))
        
        contact.relationType = pickerType.selectedRow(inComponent: 0)

        viewPickerType.isHidden = true
    }
    
    @IBAction func buttonPickerNumbersDone(_ sender: UIBarButtonItem) {
        switch phoneSMSOrWhatsApp {
            case 0:
                gPickerPhoneNumbersData[pickerPhoneNumbers.selectedRow(inComponent: 0)].description.makeACall()
            case 1:
                gPickerPhoneNumbersData[pickerPhoneNumbers.selectedRow(inComponent: 0)].description.sendSMS()
            case 2: break;
            default: break;
        }
        
        let alert = UIAlertController(title: "Numero predefinito", message: "Utilizzare il numero selezionato come predefinito?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Si", style: UIAlertActionStyle.default, handler: { action in
            switch self.phoneSMSOrWhatsApp {
                case 0:
                    updateDefaultPhoneNumber(self.contact.contact.identifier, gPickerPhoneNumbersData[self.pickerPhoneNumbers.selectedRow(inComponent: 0)].description)
                    
                    self.contact.defaultPhone = gPickerPhoneNumbersData[self.pickerPhoneNumbers.selectedRow(inComponent: 0)].description
                case 1:
                    updateDefaultSMSNumber(self.contact.contact.identifier, gPickerPhoneNumbersData[self.pickerPhoneNumbers.selectedRow(inComponent: 0)].description)
                    
                    self.contact.defaultSMS = gPickerPhoneNumbersData[self.pickerPhoneNumbers.selectedRow(inComponent: 0)].description
                case 2:
                    updateDefaultWhatsAppNumber(self.contact.contact.identifier, gPickerPhoneNumbersData[self.pickerPhoneNumbers.selectedRow(inComponent: 0)].description)
                    
                    self.contact.defaultWhatsApp = gPickerPhoneNumbersData[self.pickerPhoneNumbers.selectedRow(inComponent: 0)].description
                default: break
            }
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        
        self.present(alert, animated: true, completion: nil)
        viewPickerPhoneNumbers.isHidden = true
    }

    @IBAction func buttonPickerTypeCancel(_ sender: UIBarButtonItem) {
        viewPickerType.isHidden = true
    }
    
    @IBAction func buttonPickerNumbersCancel(_ sender: UIBarButtonItem) {
        viewPickerPhoneNumbers.isHidden = true
    }
}
