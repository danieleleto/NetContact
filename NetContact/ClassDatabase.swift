//
//  CoreDataUtils.swift
//  NetContact
//
//  Created by Luca Colombano on 31/05/18.
//  Copyright © 2018 Aral. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

func getUserData(_ contact_id: String, _ user: MyContact) {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
    request.predicate = NSPredicate(format: "contact_id = %@", contact_id)
    request.returnsObjectsAsFaults = false
    do {
        let result = try context.fetch(request)
        
        if (result.count != 0) {
            let userData = result[0] as! NSManagedObject
            user.rating = userData.value(forKey: "rating") as! Int
            user.relationType = userData.value(forKey: "type") as! Int
            if (userData.value(forKey: "default_email") != nil) {
                user.defaultEmail = userData.value(forKey: "default_email") as! String
            }
            if (userData.value(forKey: "default_phone") != nil) {
                user.defaultPhone = userData.value(forKey: "default_phone") as! String
            }
            if (userData.value(forKey: "default_sms") != nil) {
                user.defaultSMS = userData.value(forKey: "default_sms") as! String
            }
            if (userData.value(forKey: "default_whatsapp") != nil) {
                user.defaultWhatsApp = userData.value(forKey: "default_whatsapp") as! String
            }
        }
    } catch {}
}

func getDefaultEmail(_ contact_id: String) -> String {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
    request.predicate = NSPredicate(format: "contact_id = %@", contact_id)
    request.returnsObjectsAsFaults = false
    do {
        let result = try context.fetch(request)
        
        if (result.count == 0) {
            return ""
        } else {
            let userData = result[0] as! NSManagedObject
            return userData.value(forKey: "default_email") as! String
        }
    } catch {
        return ""
    }
}

func getDefaultPhone(_ contact_id: String) -> String {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
    request.predicate = NSPredicate(format: "contact_id = %@", contact_id)
    request.returnsObjectsAsFaults = false
    do {
        let result = try context.fetch(request)
        
        if (result.count == 0) {
            return ""
        } else {
            let userData = result[0] as! NSManagedObject
            return userData.value(forKey: "default_phone") as! String
        }
    } catch {
        return ""
    }
}

func getDefaultSMS(_ contact_id: String) -> String {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
    request.predicate = NSPredicate(format: "contact_id = %@", contact_id)
    request.returnsObjectsAsFaults = false
    do {
        let result = try context.fetch(request)
        
        if (result.count == 0) {
            return ""
        } else {
            let userData = result[0] as! NSManagedObject
            return userData.value(forKey: "default_sms") as! String
        }
    } catch {
        return ""
    }
}

func getDefaultWhatsApp(_ contact_id: String) -> String {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
    request.predicate = NSPredicate(format: "contact_id = %@", contact_id)
    request.returnsObjectsAsFaults = false
    do {
        let result = try context.fetch(request)
        
        if (result.count == 0) {
            return ""
        } else {
            let userData = result[0] as! NSManagedObject
            return userData.value(forKey: "default_whatsapp") as! String
        }
    } catch {
        return ""
    }
}

func getRating(_ contact_id: String) -> Int {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
    request.predicate = NSPredicate(format: "contact_id = %@", contact_id)
    request.returnsObjectsAsFaults = false
    do {
        let result = try context.fetch(request)
        
        if (result.count == 0) {
            return 0
        } else {
            let userData = result[0] as! NSManagedObject
            return userData.value(forKey: "rating") as! Int
        }
    } catch {
        return 0
    }
}

func getType(_ contact_id: String) -> Int {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
    request.predicate = NSPredicate(format: "contact_id = %@", contact_id)
    request.returnsObjectsAsFaults = false
    do {
        let result = try context.fetch(request)
        
        if (result.count == 0) {
            return 0
        } else {
            let userData = result[0] as! NSManagedObject
            return userData.value(forKey: "type") as! Int
        }
    } catch {
        return 0
    }
}

func updateDefaultEmail(_ contact_id: String, _ email: String) {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
    request.predicate = NSPredicate(format: "contact_id = %@", contact_id)
    request.returnsObjectsAsFaults = false
    do {
        let result = try context.fetch(request)
        
        if (result.count == 0) {
            let entity = NSEntityDescription.entity(forEntityName: "UserData", in: context)
            let newUserData = NSManagedObject(entity: entity!, insertInto: context)
            newUserData.setValue(contact_id, forKey: "contact_id")
            newUserData.setValue(email, forKey: "default_email")
        } else {
            let userData = result[0] as! NSManagedObject
            userData.setValue(email, forKey: "default_email")
        }
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    } catch {
        print("Failed")
    }
}

func updateDefaultPhoneNumber(_ contact_id: String, _ phoneNumber: String) {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
    request.predicate = NSPredicate(format: "contact_id = %@", contact_id)
    request.returnsObjectsAsFaults = false
    do {
        let result = try context.fetch(request)
        
        if (result.count == 0) {
            let entity = NSEntityDescription.entity(forEntityName: "UserData", in: context)
            let newUserData = NSManagedObject(entity: entity!, insertInto: context)
            newUserData.setValue(contact_id, forKey: "contact_id")
            newUserData.setValue(phoneNumber, forKey: "default_phone")
        } else {
            let userData = result[0] as! NSManagedObject
            userData.setValue(phoneNumber, forKey: "default_phone")
        }
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    } catch {
        print("Failed")
    }
}

func updateDefaultSMSNumber(_ contact_id: String, _ smsNumber: String) {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
    request.predicate = NSPredicate(format: "contact_id = %@", contact_id)
    request.returnsObjectsAsFaults = false
    do {
        let result = try context.fetch(request)
        
        if (result.count == 0) {
            let entity = NSEntityDescription.entity(forEntityName: "UserData", in: context)
            let newUserData = NSManagedObject(entity: entity!, insertInto: context)
            newUserData.setValue(contact_id, forKey: "contact_id")
            newUserData.setValue(smsNumber, forKey: "default_sms")
        } else {
            let userData = result[0] as! NSManagedObject
            userData.setValue(smsNumber, forKey: "default_sms")
        }
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    } catch {
        print("Failed")
    }
}

func updateDefaultWhatsAppNumber(_ contact_id: String, _ whatsAppNumber: String) {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
    request.predicate = NSPredicate(format: "contact_id = %@", contact_id)
    request.returnsObjectsAsFaults = false
    do {
        let result = try context.fetch(request)
        
        if (result.count == 0) {
            let entity = NSEntityDescription.entity(forEntityName: "UserData", in: context)
            let newUserData = NSManagedObject(entity: entity!, insertInto: context)
            newUserData.setValue(contact_id, forKey: "contact_id")
            newUserData.setValue(whatsAppNumber, forKey: "default_whatsapp")
        } else {
            let userData = result[0] as! NSManagedObject
            userData.setValue(whatsAppNumber, forKey: "default_whatsapp")
        }
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    } catch {
        print("Failed")
    }
}

func updateRating(_ contact_id: String, _ rating: Int) {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
    request.predicate = NSPredicate(format: "contact_id = %@", contact_id)
    request.returnsObjectsAsFaults = false
    do {
        let result = try context.fetch(request)
        
        if (result.count == 0) {
            let entity = NSEntityDescription.entity(forEntityName: "UserData", in: context)
            let newUserData = NSManagedObject(entity: entity!, insertInto: context)
            newUserData.setValue(contact_id, forKey: "contact_id")
            newUserData.setValue(rating, forKey: "rating")
        } else {
            let userData = result[0] as! NSManagedObject
            userData.setValue(rating, forKey: "rating")
        }
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    } catch {
        print("Failed")
    }
}

func updateType(_ contact_id: String, _ type: Int) {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
    request.predicate = NSPredicate(format: "contact_id = %@", contact_id)
    request.returnsObjectsAsFaults = false
    do {
        let result = try context.fetch(request)
        
        if (result.count == 0) {
            let entity = NSEntityDescription.entity(forEntityName: "UserData", in: context)
            let newUserData = NSManagedObject(entity: entity!, insertInto: context)
            newUserData.setValue(contact_id, forKey: "contact_id")
            newUserData.setValue(type, forKey: "type")
        } else {
            let userData = result[0] as! NSManagedObject
            userData.setValue(type, forKey: "type")
        }
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    } catch {
        print("Failed")
    }
}
