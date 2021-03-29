//
//  SubscribeVC.swift
//  Cleaner
//
//  Created by fst on 2021/3/25.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa

class SubscribeVC: BaseVC {
   
    
    @IBOutlet weak var weekBTn: UIButton!
    
    @IBOutlet weak var monthBtn: UIButton!
    
    @IBOutlet weak var quarterBtn: UIButton!
    
    
    @IBOutlet weak var subscribeBtn: QMUIButton!

    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var topViewHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var itemTopInsetCons: NSLayoutConstraint!
    
    @IBOutlet weak var useProtocolBtn: UIButton!
    
    @IBOutlet weak var privateProtocolBtn: UIButton!
    
    @IBOutlet weak var restoreBtn: UIButton!
    
    //成功订阅block
    var successBlock:()->Void = { }
    
    var selectBtn:UIButton?
    var productID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        
        selectBtn = weekBTn
        productID = subscribeItems[0]
        self.view.backgroundColor = HEX("28B3FF")
        
        weekBTn.layer.cornerRadius = 25
        weekBTn.layer.masksToBounds = true
        monthBtn.layer.cornerRadius = 25
        monthBtn.layer.masksToBounds = true
        quarterBtn.layer.cornerRadius = 25
        quarterBtn.layer.masksToBounds = true
        
        subscribeBtn.layer.cornerRadius = 30
        subscribeBtn.layer.masksToBounds = true
        
        self.topViewHeightCons.constant = iPhoneX ? 340 :280
        self.itemTopInsetCons.constant = iPhoneX ? 70 :40
        
        if PaymentTool.shared.productDict.isEmpty {
            PaymentTool.shared.requestProducts(productArray: subscribeItems)
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.qmui_item(with: UIImage(named: "close"), target: self, action: #selector(closeBtnACtion))

        let str = NSMutableAttributedString(string: "使用条款")
        let strRange = NSRange(location: 0, length: str.length)
        str.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: strRange)
        useProtocolBtn.setAttributedTitle(str, for: .normal)
        
        let str2 = NSMutableAttributedString(string: "隐私政策")
        let strRange2 = NSRange(location: 0, length: str.length)
        str2.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: strRange2)
        privateProtocolBtn.setAttributedTitle(str2, for: .normal)
        
        let str3 = NSMutableAttributedString(string: "恢复购买")
        let strRange3 = NSRange(location: 0, length: str.length)
        str3.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: strRange3)
        restoreBtn.setAttributedTitle(str3, for: .normal)
        
//        NotificationCenter.default.rx.notification(UIResponder.keyboardDidHideNotification).subscribe(onNext: { noti in
//               QMUITips.hideAllTips()
//        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.topView.cornerWith(byRoundingCorners: [.bottomLeft,.bottomRight], radii: 20)
    }
    
    override func preferredNavigationBarHidden() -> Bool {
        return false
    }
    
    override func navigationBarBackgroundImage() -> UIImage? {
        return UIImage.qmui_image(with: .white)
    }
    
    override func navigationBarTintColor() -> UIColor? {
        return HEX("28B3FF")
    }
    
    
    @IBAction func itemACtion(_ sender: UIButton) {
        selectBtn?.isSelected = false
        sender.isSelected = true
        selectBtn = sender
        productID = subscribeItems[sender.tag]
    }
    
    @IBAction func subscribeBtnAction(_ sender: QMUIButton) {
        PaymentTool.shared.buyProduct(productID: productID) { (isSuccess) in
            //订阅成功
            if isSuccess{
                self.dismiss(animated: true) {
                    self.successBlock()
                }
            }else{
                QMUITips.show(withText: "订阅失败")
            }
        }
    }
    
    
     @objc func closeBtnACtion() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func restoreBtnAction(btn:UIButton) {
        PaymentTool.shared.restorePurchase { (isSuccess) in
            self.dismiss(animated: true) {
                self.successBlock()
            }
        }
    }
    
    
    @IBAction func protocolBtn(_ sender: UIButton) {
        let vc = WebVC()
        vc.titleStr = sender.tag == 0 ? "用户协议":"隐私政策"
        vc.url = "https://shimo.im/docs/TcWH8jx8pyTyq8Rk"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
