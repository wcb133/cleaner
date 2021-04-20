//
//  CalanderVC.swift
//  Cleaner
//
//  Created by fst on 2021/3/21.
//
import QMUIKit
import WMPageController

class CalendarManagerVC: WMPageController {
    
    var refreshUIBlock:()->Void = {}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage.qmui_image(with: HEX("28B3FF")), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage.qmui_image(with: HEX("#E5E5E5"), size: CGSize(width: cScreenWidth, height: 1), cornerRadius: 0)
    }
    
    /// 自定义导航栏返回item或隐藏导航栏之后，侧滑功能是否打开
    override func forceEnableInteractivePopGestureRecognizer() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "日历及提醒"
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont(name: "PingFang-SC-Medium", size: 18)!,NSAttributedString.Key.foregroundColor:UIColor.white]

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setup() {
        self.titleColorNormal = HEX("#666666")
        self.titleColorSelected = HEX("FFBE57")
        self.titleSizeNormal = 18
        self.titleSizeSelected = 18
        self.progressViewBottomSpace = 0
        self.menuViewContentMargin = 0
        self.menuViewLayoutMode = .center
        self.menuViewStyle = .line
        self.progressViewWidths = [80,110]
        self.progressHeight = 2
    }
    
    override func numbersOfChildControllers(in pageController: WMPageController) -> Int {
        return 2
    }
    
    override func pageController(_ pageController: WMPageController, titleAt index: Int) -> String {
        return index == 0 ? "过期日历":"过期提醒事项";
    }
    
    
    override func menuView(_ menu: WMMenuView!, widthForItemAt index: Int) -> CGFloat {
        return cScreenWidth / 2
    }
    
    override func pageController(_ pageController: WMPageController, viewControllerAt index: Int) -> UIViewController {
        let vc = CalendarAndReminderVC()
        vc.isCalendar = index == 0
        vc.refreshUIBlock = self.refreshUIBlock
        return vc
    }
    
    override func pageController(_ pageController: WMPageController, preferredFrameFor menuView: WMMenuView) -> CGRect {
        return CGRect(x: 0, y: 0, width: self.view.qmui_width, height: 50)
    }
    
    override func pageController(_ pageController: WMPageController, preferredFrameForContentView contentView: WMScrollView) -> CGRect {
        guard let menuView = menuView  else { return CGRect.zero }
        menuView.backgroundColor = HEX("#F7F8FB")
        let originY:CGFloat = self.pageController(pageController, preferredFrameFor: menuView).maxY
        return CGRect(x: 0, y: originY, width: self.view.qmui_width, height: self.view.qmui_height - originY);
    }
    
}


