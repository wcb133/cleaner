//
//  ClearContactManager.swift
//  Cleaner
//
//  Created by fst on 2021/3/16.
//

import UIKit
import Contacts
import AddressBook

class ContactSectonModel: NSObject {
    var name:String = ""
    var contactModels:[ContactModel] = []
}

class ContactModel: NSObject {
    var name:String = ""
    var tel:String = ""
}

class ContactManager: NSObject {
    
    static let shared: ContactManager = {
        let instance = ContactManager()
        return instance
    }()
    
    //获取重复联系人
    func getRepeatContact(complete:@escaping ([ContactSectonModel],Int)->Void) {
        let status = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        if status == .notDetermined {
            let contactStore = CNContactStore()
            contactStore.requestAccess(for: CNEntityType.contacts) { (granted, error) in
                if granted {
                    self.loadContact(complete: complete)
                }
            }
        }else if status == .authorized {//已授权
            self.loadContact(complete: complete)
        }else{//拒绝授权，弹框提示
            
        }
    }
    
    private func loadContact(complete:@escaping ([ContactSectonModel],Int)->Void) {
        
        var contactCount = 0
        
        var contactDict:[String:[ContactModel]] = [:]
        var contactSectonModels:[ContactSectonModel] = []
        let contactStore = CNContactStore()
        /*
         
         for (CNContact *contact in contacts) {
             CNMutableContact *contact1 = [contact mutableCopy];
             // 删除联系人
             [saveRequest deleteContact:contact1];
         }
        */
//        let re = CNSaveRequest()
//        let contact = CNMutableContact()
//        re.delete(contact)
//        [store executeSaveRequest:saveRequest error:nil]
        let key = [CNContactFamilyNameKey,CNContactGivenNameKey,CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: key)
        do {
            try contactStore.enumerateContacts(with: request, usingBlock: { (contact, stop) in
                
                contactCount += 1
                
                
                let lastName = contact.familyName
                let firstName = contact.givenName
                let name = "\(lastName)\(firstName)"

                print("姓名：\(lastName)\(firstName)")
                
                let model = ContactModel()
                
                model.name = name
                // 遍历电话号码
                let phoneNums = contact.phoneNumbers
                for phoneNumber in phoneNums {
                    model.tel = phoneNumber.value.stringValue
                }
                
                if var contactModels = contactDict[name] {
                    contactModels.append(model)
                    contactDict[name] = contactModels
                }else{
                    contactDict[name] = [model]
                }
            })
            
            for key in contactDict.keys {
                let contactModels = contactDict[key] ?? []
                if contactModels.count > 1 {
                    print("重复的姓名：\(key)")
                    let contactSectonModel = ContactSectonModel()
                    contactSectonModel.name = key
                    contactSectonModel.contactModels = contactModels
                    contactSectonModels.append(contactSectonModel)
                }
            }
            complete(contactSectonModels,contactCount)
            
        } catch  {
            print("获取通讯录出错")
            return
        }
    }
}
