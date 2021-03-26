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
        BaiduMobStat.default().start(withAppId: "111912a685")
        
        //设置友盟appkey
        UMConfigure.initWithAppkey(UMentKeyStr, channel: "App Store")
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        let vc = mainVC()
        let navVc = BaseNav(rootViewController: vc)
        window?.rootViewController = navVc
        
        //qmui全局设置
        let config = QMUIConfiguration.sharedInstance()
        config?.automaticCustomNavigationBarTransitionStyle = false
        
        //订阅监听
        PaymentTool.shared.addObserver()
        PaymentTool.shared.requestProducts(productArray: subscribeItems)
        
        return true
    }
}

