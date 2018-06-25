//
//  Globals.swift
//  NetContact
//
//  Created by Luca Colombano on 30/05/18.
//  Copyright © 2018 Aral. All rights reserved.
//

import Foundation
import Contacts

var gContact = MyContact()
var gContacts = [MyContact]()
var gContactsForListView = [MyContact()]
var gPickerPhoneNumbersTypeData = [String]()
var gPickerPhoneNumbersData = [String]()
var gPickerEmailsData = [String]()
var gCurrentRow = IndexPath()

let gPickerTypeData = ["N.D.", "Potenziale", "Presentazione", "Cliente", "Collaboratore"]

