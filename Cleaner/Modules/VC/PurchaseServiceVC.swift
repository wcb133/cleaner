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


class PurchaseServiceVC: AppBaseVC {
   
    
    
    @IBOutlet weak var weekBTn: UIButton!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var topViewHeightCons: NSLayoutConstraint!
    
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
        
        self.topViewHeightCons.constant = iPhoneX ? 390 :340
        
        if PaymentManager.shared.productDict.isEmpty {
            PaymentManager.shared.requestProducts(productArray: subscribeItems)
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.qmui_item(with: UIImage(named: "close"), target: self, action: #selector(closeBtnACtion))

        let str = NSMutableAttributedString(string: localizedString("Use Agreement"))
        let strRange = NSRange(location: 0, length: str.length)
        str.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: strRange)
        useProtocolBtn.setAttributedTitle(str, for: .normal)
        
        let str2 = NSMutableAttributedString(string: localizedString("Privacy Policy"))
        let strRange2 = NSRange(location: 0, length: str2.length)
        str2.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: strRange2)
        privateProtocolBtn.setAttributedTitle(str2, for: .normal)
        
        let str3 = NSMutableAttributedString(string: localizedString("Restore"))
        let strRange3 = NSRange(location: 0, length: str3.length)
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
        productID = subscribeItems[0]
        PaymentManager.shared.buyProduct(productID: productID) { (isSuccess) in
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
        PaymentManager.shared.restorePurchase { (isSuccess) in
            self.dismiss(animated: true) {
                self.successBlock()
            }
        }
    }
    
    
    @IBAction func protocolBtn(_ sender: UIButton) {
        let vc = AppWebVC()
        vc.titleStr = sender.tag == 0 ? "使用条款":"隐私政策"
        let pathOne = Bundle.main.path(forResource: "隐私政策", ofType: "html") ?? ""
        vc.path = pathOne
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
