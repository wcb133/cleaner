//
//  AppDelegate.swift
//  Cleaner
//
//  Created by fst on 2021/3/12.
//

import UIKit
import QMUIKit



let weekSub = "w01"
let monthSub = "w02"
let quarterSub = "w03"

let subscribeItems = [weekSub,monthSub,quarterSub]

//友盟key
let UMentKeyStr = "605db577b8c8d45c13b23381"
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //百度统计
//        let statTracker = BaiduMobStat.default()
//        statTracker.enableDebugOn = false
//        #if false
//              statTracker.start(withAppId: "111912a685")
//        #else
//              statTracker.start(withAppId: "9ff5e41c7e")
//        #endif
        
        //设置友盟appkey
//        UMConfigure.initWithAppkey(UMentKeyStr, channel: "App Store")
        //leancloud
//        AVOSCloud.setApplicationId("BCyffpvafyN9QkcxC6TCaVaR-gzGzoHsz", clientKey: "gxG1YQc15y60r8hDWulAh5GR", serverURLString: "https://bcyffpva.lc-cn-n1-shared.com")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        let vc = HomeVC()
        let navVc = AppBaseNav(rootViewController: vc)
        window?.rootViewController = navVc
        
        //qmui全局设置
        let config = QMUIConfiguration.sharedInstance()
        config?.automaticCustomNavigationBarTransitionStyle = false
        
        //订阅监听
        PaymentManager.shared.addObserver()
        PaymentManager.shared.requestProducts(productArray: subscribeItems)
        //本地化
        object_setClass(Foundation.Bundle.main, Bundle.self)
        
        return true
    }
}

