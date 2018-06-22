//
//  MyContact.swift
//  NetContact
//
//  Created by Luca Colombano on 30/05/18.
//  Copyright © 2018 Aral. All rights reserved.
//

import UIKit
import Contacts

class MyContact: NSObject {
    var contact = CNContact()
    var rating   : Int = 0
    var relationType  : Int = 0
    var defaultEmail : String = ""
    var defaultPhone : String = ""
    var defaultSMS : String = ""
    var defaultWhatsApp : String = ""
}
