//
//  HCLoginCustomTool.swift
//  HippoCharge
//
//  Created by jemi on 2020/5/25.
//  Copyright © 2020 leon. All rights reserved.
//

import UIKit

class HCLoginCustomTool: NSObject {
    
    ///是否游客登录
    @objc class func isPassengerLogin() -> Bool{
//        if HRAppManager.shared.token.isEmpty {
//            return true
//        }
        return false
    }
    
    
    /// 判断是否未登录
    /// - Parameter complete: 登录成功之后的回调
    ///return:true未登录,false已登录
    @objc class func handlePassengerLoginPresent(complete:@escaping () ->Void) -> Bool {
        if HCLoginCustomTool.isPassengerLogin() {
//            let vc = BKLoginVC()
//            vc.turnToVCType = {
//                complete()
//            }
//             HRNavigationController.currentNavigationController()?.pushViewController(vc, animated: true)
            return true
        }
        return false
    }
    
    ///退出登录
    class func userLoginOut() {
        
//        HCUMTool.removeUMPushTag()
//        
//        HRAppManager.shared.userId = ""
//        HRAppManager.shared.token = ""
//        HRAppManager.shared.phone = ""
//        HRAppManager.shared.avatarUrl = ""
//        HCWXAuth.shared.headimgurl = ""
//        HCWXAuth.shared.unionid = ""
//        HCWXAuth.shared.openid = ""
//        UserDefaults.UserInfo.set(value: "", forKey: .token)
//        UserDefaults.UserInfo.set(value: "", forKey: .userId)
//        UserDefaults.UserInfo.set(value: "", forKey: .phone)
//        UserDefaults.UserInfo.set(value: "", forKey: .avatarUrl)
        
    }

}
