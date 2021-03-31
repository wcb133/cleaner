//
//  BKOrderManagerVC.swift
//  BankeBus
//
//  Created by jemi on 2020/12/2.
//  Copyright © 2020 jemi. All rights reserved.
//

import UIKit
import WMPageController

class BKOrderManagerVC: WMPageController {
    
    var orderType:BKOrderTag = .carOrder
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage.qmui_image(with: .white), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage.qmui_image(with: HEX("#E5E5E5"), size: CGSize(width: cScreenWidth, height: 1), cornerRadius: 0)
    }
    
    /// 自定义导航栏返回item或隐藏导航栏之后，侧滑功能是否打开
    override func forceEnableInteractivePopGestureRecognizer() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        navigationController?.navigationBar.shadowImage = UIImage()
      
        self.navigationController?.navigationBar.tintColor = HEX("#666666")
        view.backgroundColor = HEX("#F4F7FA")
        
    }
    
    func setup(){
        if orderType == .carOrder {
            self.title = "车辆订单"
        }else {
            self.title = "商城订单"
        }
        
        
        self.progressViewWidths = [30,48,48,48,48]
        self.titleColorNormal = HEX("#666666")
        self.titleColorSelected = HEX("#333333")
        self.progressHeight = 4
        self.titleSizeNormal = 15
        self.titleSizeSelected = 18
        self.titleFontName = "PingFang-SC-Medium"
        self.progressColor = HEX("#3890F9");
        self.progressViewBottomSpace = 0
        self.menuViewContentMargin = 0
        self.menuViewLayoutMode = .center
        self.menuViewStyle = .line
    }
    
    override func numbersOfChildControllers(in pageController: WMPageController) -> Int {
        return 5
    }
    
    override func pageController(_ pageController: WMPageController, titleAt index: Int) -> String {
        if orderType == .carOrder {
            switch index {
            case 0:
                return "全部"
            case 1:
                return "待处理"
            case 2:
                return "已接受"
            case 3:
                return "已拒绝"
            case 4:
                return "已完成"
            default:
                return ""
            }
        }else {
            switch index {
            case 0:
                return "全部"
            case 1:
                return "待付款"
            case 2:
                return "待发货"
            case 3:
                return "待收货"
            case 4:
                return "待评价"
            default:
                return ""
            }
        }
    }
    
    
    override func menuView(_ menu: WMMenuView!, widthForItemAt index: Int) -> CGFloat {
        return cScreenWidth/5
    }
    
    override func pageController(_ pageController: WMPageController, viewControllerAt index: Int) -> UIViewController {
        if orderType == .carOrder {
            return BKOrderVC.init(BKOrderStatus(rawValue: index)!)
        }else {
            return BKShopOrderVC.init(BKOrderStatus(rawValue: index)!)
        }
    }
    
    override func pageController(_ pageController: WMPageController, preferredFrameFor menuView: WMMenuView) -> CGRect {
        return CGRect(x: 0, y: 0, width: self.view.qmui_width, height: 44)
    }
    
    override func pageController(_ pageController: WMPageController, preferredFrameForContentView contentView: WMScrollView) -> CGRect {
        guard let menuView = menuView  else { return CGRect.zero }
        menuView.backgroundColor = HEX("#F9F9F9")
        let originY:CGFloat = self.pageController(pageController, preferredFrameFor: menuView).maxY
        return CGRect(x: 0, y: originY, width: self.view.qmui_width, height: self.view.qmui_height - originY);
    }
    
}


extension BKOrderManagerVC{
    convenience init(_ type:BKOrderTag) {
        self.init()
        self.orderType = type
    }
}

enum BKOrderTag:Int {
    case carOrder = 0    //车辆订单
    case shopOrder = 1 //商品订单
}
