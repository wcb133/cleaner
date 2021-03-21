//
//  AppDelegate.swift
//  Cleaner
//
//  Created by fst on 2021/3/12.
//

import UIKit
import QMUIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        let vc = mainVC()
        let navVc = BaseNav(rootViewController: vc)
        window?.rootViewController = navVc
        
        //qmui全局设置
        let config = QMUIConfiguration.sharedInstance()
        config?.automaticCustomNavigationBarTransitionStyle = false
        return true
    }
}

