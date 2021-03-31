//
//  BKOrderDetailInvoiceView.swift
//  BankeBus
//
//  Created by fst on 2021/3/25.
//  Copyright © 2021 jemi. All rights reserved.
//

import UIKit
import WebKit

class BKOrderDetailInvoiceView: UITableViewHeaderFooterView,LoadNibable {
    
    //本人开票
    @IBOutlet weak var oneSelfBTn: UIButton!
    @IBOutlet weak var companyBtn: UIButton!
    //查看须知
    @IBOutlet weak var noticeBtn: UIButton!
    
    
    @IBOutlet weak var containerTopInsetCons: NSLayoutConstraint!
    //分割线下半部分view
    @IBOutlet weak var containerView: UIView!
    
    
    @IBOutlet weak var companySelectBtn: QMUIButton!
    @IBOutlet weak var changeToOtherAddressBtn: QMUIButton!
    
    
    @IBOutlet weak var companyAddressLab: UILabel!
    @IBOutlet weak var selectAddressBtn: QMUIButton!
    //开发票信息以及流程
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var companyNameLab: UILabel!
    
    @IBOutlet weak var IDLab: UILabel!
    
    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var telLab: UILabel!
    
    @IBOutlet weak var addressLab: UILabel!
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var webViewHeightCons: NSLayoutConstraint!
    
    
    //业务公司地址切换
    var addressChangeBlock:()->Void = {}
    //开票方式切换
    var invoiceTypeChangeBlock:()->Void = {}
    
    //用户选择的省份与城市
    var selectProvince = ""
    var selectCity = ""
    
    //当前勾选的省份与城市
    var province = ""
    var city = ""
    
    
    //是否是企业代开
    var isBillingAgent = false {
        didSet{
            if isBillingAgent {
                self.containerView.isHidden = true
                self.containerTopInsetCons.constant = 8
            }else{
                self.containerView.isHidden = false
                self.containerTopInsetCons.constant = 0
            }
        }
    }
    
    var htmlString = ""
    override func awakeFromNib() {
        oneSelfBTn.layer.cornerRadius = 15
        oneSelfBTn.layer.masksToBounds = true
        
        scrollview.layer.cornerRadius = 6
        scrollview.layer.masksToBounds = true

        companyBtn.layer.borderWidth = 1
        companyBtn.layer.borderColor = HEX("#999999").cgColor
        companyBtn.layer.cornerRadius = 15
        companyBtn.layer.masksToBounds = true
        
        selectAddressBtn.imagePosition = .right
        webView.scrollView.backgroundColor = .clear
        
        let searchInputObOne = self.webView.scrollView.rx.observeWeakly(CGSize.self, "contentSize").asObservable()
        searchInputObOne.subscribe(onNext: { (contentSize) in
            guard  let contentH = contentSize?.height else { return }
            if contentH < 40 || !self.noDataLab.isHidden {
                self.webViewHeightCons.constant = 40
            }else{
                self.webViewHeightCons.constant = contentH
            }
            
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)
    }
    
    var dataModel = BKOrderModel(){
        didSet{
            
            let businessCompanyValue = dataModel.businessCompany.businessCompanyValue
            self.companyNameLab.text = "公司名称：" + businessCompanyValue.name
            self.IDLab.text = "纳税识别号：" + businessCompanyValue.taxIdNumber
            
            self.nameLab.text = "收件人：" + businessCompanyValue.chargerName
            self.telLab.text = "手机号：" + businessCompanyValue.chargerPhone
            self.addressLab.text = "收件地址：" + businessCompanyValue.receivingAddress
            
            
            self.province = dataModel.businessCompany.cityValue.province
            self.city = dataModel.businessCompany.cityValue.city
            self.companyAddressLab.text = dataModel.businessCompany.cityValue.province + dataModel.businessCompany.cityValue.city
            if dataModel.canBillingAgent == false {
                self.companyBtn.isEnabled = false
                self.companyBtn.backgroundColor = HEX("#DADADA")
                self.companyBtn.setTitleColor(HEX("#666666"), for: .normal)
            }
        }
    }
    
    lazy var noDataLab: UILabel = {
        let lab = UILabel()
        lab.text = "暂时无数据"
        lab.textColor = HEX("666666")
        lab.backgroundColor = .white
        lab.textAlignment = .center
        lab.isHidden = true
        lab.font = .systemFont(ofSize: 13)
        self.webView.addSubview(lab)
        lab.snp.makeConstraints { (m) in
            m.edges.equalTo(0)
        }
        return lab
    }()
    
    func loadHtml(htmlString:String) {
        if htmlString.isEmpty {
            self.noDataLab.isHidden = false
            self.webViewHeightCons.constant = 40
            return
        }
        self.noDataLab.isHidden = true
        let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        self.htmlString = htmlString

        let dealHtmlString = htmlString.qmui_string(byReplacingPattern: "width=\"\\d+\"", with: "width=\"100%\"").qmui_string(byReplacingPattern: "height=\"\\d+\"", with: "height=\"auto\"")

        webView.loadHTMLString(headerString + dealHtmlString, baseURL: nil)
    }
    
    @IBAction func noticeBtnAction(_ sender: UIButton) {
        let vc = QMUIModalPresentationViewController()
        vc.isModal = true
        let contView = BKShowReadMeInfoView.loadNib()
        contView.closeBlock = {
            vc.hideWith(animated: true, completion: nil)
        }
        vc.contentView = contView
        vc.showWith(animated: true, completion: nil)
    }
    
    @IBAction func typeChangeACtion(_ sender: UIButton) {
        sender.backgroundColor = HEX("#3890F9")
        sender.layer.borderWidth = 0
        sender.setTitleColor(.white, for: .normal)
        
        if self.oneSelfBTn == sender {
            self.companyBtn.backgroundColor = .white
            self.companyBtn.layer.borderColor = HEX("#999999").cgColor
            self.companyBtn.layer.borderWidth = 1
            self.companyBtn.setTitleColor(HEX("#333333"), for: .normal)
        }else{
            self.oneSelfBTn.backgroundColor = .white
            self.oneSelfBTn.layer.borderColor = HEX("#999999").cgColor
            self.oneSelfBTn.layer.borderWidth = 1
            self.oneSelfBTn.setTitleColor(HEX("#333333"), for: .normal)
        }
        
        self.isBillingAgent = self.companyBtn == sender
        self.invoiceTypeChangeBlock()
    }
    
    
    @IBAction func addressChangeAction(_ sender: QMUIButton) {
        if self.companySelectBtn == sender {
            self.province = self.dataModel.businessCompany.cityValue.province
            self.city = self.dataModel.businessCompany.cityValue.city
            self.changeToOtherAddressBtn.isSelected = false
            self.addressChangeBlock()
        }else{
            self.province = self.selectProvince
            self.city = self.selectCity
            
            self.addressChangeBlock()
            self.companySelectBtn.isSelected = false
        }
        sender.isSelected = true
    }
    
    //户籍地址选择跳转
    @IBAction func selectAddressBtnAction(_ sender: QMUIButton) {
        if !self.changeToOtherAddressBtn.isSelected {
            return
        }
        
//        let vc = BKBuyCarYearVC()
//        vc.selectYearBlock = { (province,city) in
//            self.province = province
//            self.city = city
//            
//            self.selectProvince = province
//            self.selectCity = city
//            
//            self.selectAddressBtn.setTitle(province + city, for: .normal)
//            self.selectAddressBtn.setTitleColor(HEX("#333333"), for: .normal)
//            
//            self.addressChangeBlock()
//        }
//        AppBaseNav.currentNavigationController()?.pushViewController(vc, animated: true)
    }
}
