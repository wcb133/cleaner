//
//  ClearContactAnalyseTool.swift
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
    
    var contact:CNContact!
    
    var isSelected = false
}

class ContactAnalyseTool: NSObject {
    
    static let shared: ContactAnalyseTool = {
        let instance = ContactAnalyseTool()
        return instance
    }()
    
    let contactStore = CNContactStore()
    
    //获取重复联系人
    func getAllRepeatContacts(complete:@escaping ([ContactSectonModel],Int)->Void) {
        let status = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        if status == .notDetermined {
            let contactStore = CNContactStore()
            contactStore.requestAccess(for: CNEntityType.contacts) { (granted, error) in
                DispatchQueue.main.async {
                    if granted {
                        self.loadAllContacts(complete: complete)
                    }else{
                            self.noticeAlert()
                        }
                }
            }
        }else if status == .authorized {//已授权
            self.loadAllContacts(complete: complete)
        }else{//拒绝授权，弹框提示
            self.noticeAlert()
        }
    }
    
    private func loadAllContacts(complete:@escaping ([ContactSectonModel],Int)->Void) {
        
        var contactCount = 0
        
        var contactDict:[String:[ContactModel]] = [:]
        var contactSectonModels:[ContactSectonModel] = []
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
                model.contact = contact
                // 遍历电话号码
                let phoneNums = contact.phoneNumbers
                for phoneNumber in phoneNums {
                    model.tel = phoneNumber.value.stringValue
                }
                
                if var contactModels = contactDict[name] {
                    //选中重复的联系人
                    model.isSelected = true
                    contactModels.append(model)
                    contactDict[name] = contactModels
                }else{
                    contactDict[name] = [model]
                }
            })
            
//            let keys = contactDict.sorted(by: {$0.0 < $1.0})
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
    
    //删除联系人
    func deleteSelectContacts(contacts:[ContactModel]) {
        let re = CNSaveRequest()
        for contact in contacts {
            let contactM = contact.contact.mutableCopy() as! CNMutableContact
            re.delete(contactM)
        }
        try? contactStore.execute(re)
    }
    
    //弹框提示开启权限
    func noticeAlert() {
        let alert = UIAlertController(title: "此功能需要通讯录授权", message: "请您在设置系统中打开授权开关", preferredStyle: .alert);
        let left = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let right = UIAlertAction(title: "前往设置", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(left)
        alert.addAction(right)
        let vc = cKeyWindow!.rootViewController
        vc?.present(alert, animated: true, completion: nil)
    }
}
