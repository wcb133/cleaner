//
//  BaseVC.swift
//  Cleaner
//
//  Created by fst on 2021/3/15.
//

import UIKit
import SnapKit
import QMUIKit

class BaseVC: QMUICommonViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = false
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .white
        titleView?.titleLabel.font = UIFont(name: "PingFang-SC-Medium", size: 18)!
        bindViewModel()
    }

    func bindViewModel() {}
}


extension BaseVC {
    
    /// 接管导航栏的隐藏和显示
    override func shouldCustomizeNavigationBarTransitionIfHideable() -> Bool {
        return true
    }
    
    /// 自定义导航栏返回item或隐藏导航栏之后，侧滑功能是否打开
    override func forceEnableInteractivePopGestureRecognizer() -> Bool {
        if BaseNav.currentNavigationController()?.viewControllers.count ?? 0 > 1 {
            return true
        }
        return false
    }
    
    override func backBarButtonItemTitle(withPreviousViewController viewController: UIViewController?) -> String? {
        return "  "
    }
    
    override func preferredNavigationBarHidden() -> Bool {
        return false
    }
    
    override func navigationBarBackgroundImage() -> UIImage? {
        return UIImage.qmui_image(with: HEX("28B3FF"))
    }
    
    override func navigationBarTintColor() -> UIColor? {
        return .white
    }

    override func navigationBarShadowImage() -> UIImage? {
        return UIImage()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
