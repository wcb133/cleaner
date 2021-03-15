//
//  HCBaseNavigationController.swift
//  HippoCharge
//
//  Created by jemi on 2020/5/15.
//  Copyright © 2020 leon. All rights reserved.
//

import QMUIKit

class BaseNav: QMUINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        if viewControllers.count >= 1 {
            let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "fanhui"), style: UIBarButtonItem.Style.done, target: self, action: #selector(backBtnClick))//
            leftBarButtonItem.tintColor = .black
            if #available(iOS 11.0, *){ // ios11 以上偏移
                leftBarButtonItem.imageInsets = UIEdgeInsets(top: 2, left: -2, bottom: 0, right: 0)
                viewController.navigationItem.leftBarButtonItem = leftBarButtonItem
            } else {
                let nagetiveSpacer = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
                nagetiveSpacer.width = -2//这个值可以根据自己需要自己调整
                viewController.navigationItem.leftBarButtonItems = [nagetiveSpacer, leftBarButtonItem]
            }
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc func backBtnClick() {
        popViewController(animated: true)
    }
    
    class func currentViewController() -> UIViewController {
        return UIApplication.shared.txs_topViewController()
    }
    
    @objc class func currentNavigationController() -> UINavigationController? {
        let cur = currentViewController()
        var nav = cur.navigationController
        
        if nav == nil {
            if (cKeyWindow?.rootViewController?.isKind(of: UITabBarController.self)) != nil {
                if let tabBarVc = cKeyWindow?.rootViewController as? UITabBarController {
                    if (tabBarVc.selectedViewController?.isKind(of: UINavigationController.self)) != nil {
                        nav = tabBarVc.selectedViewController as? UINavigationController
                    }
                }
            }
        }
        
        return nav
    }
}

extension UIApplication{
    func txs_topViewController() -> UIViewController{
        let vc:UIViewController = cKeyWindow!.rootViewController!
        return txs_visibleViewControllerFrom(vc)
    }
    
    func txs_visibleViewControllerFrom(_ vc:UIViewController) -> UIViewController {
        if vc.isKind(of: UINavigationController.self) {
            return txs_visibleViewControllerFrom((vc as! UINavigationController).visibleViewController!)
        }
        
        if vc.isKind(of: UITabBarController.self) {
            return txs_visibleViewControllerFrom((vc as! UITabBarController).selectedViewController!)
        }
        
        if (vc.presentedViewController != nil) {
            return txs_visibleViewControllerFrom(vc.presentedViewController!)
        }
        
        return vc
    }
}
