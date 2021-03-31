//
//  BKInvoceInfoVC.swift
//  BankeBus
//
//  Created by jemi on 2021/1/22.
//  Copyright © 2021 jemi. All rights reserved.
//

import QMUIKit
import RxSwift
import RxCocoa

class BKInvoceInfoVC: AppBaseVC {
    
    var model = BKInvoiceModel() {
        didSet {
            headView?.needIncoveBtn.isSelected = self.model.isInv
            headView?.noneedInvoceBtn.isSelected = !(self.model.isInv)
            
            if model.invPayeeType == 1 {
                headView?.personBtn.isSelected = true
                headView?.composeBtn.isSelected = false
                isPerson = true
            }else {
                headView?.personBtn.isSelected = false
                headView?.composeBtn.isSelected = true
                isPerson = false
            }
        }
    }
    
    var headView:BKInvoceView?
    
    ///发票抬头
    var invPayee = BehaviorRelay(value: "")
    var invPayeeTF = QMUITextField()
    ///税号
    var invITIN = BehaviorRelay(value: "")
    var invITINTF = QMUITextField()
    ///联系人
    var invConsignee = BehaviorRelay(value: "")
    var invConsigneeTF = QMUITextField()
    ///联系人邮箱
    var invEmail = BehaviorRelay(value: "")
    var invEmailTF = QMUITextField()
    
    var backInvoiceBlock:((BKInvoiceModel)->Void) = {_ in}
    
    var isPerson = true {
        didSet {
            dataArray.removeAll()
            pleaceArray.removeAll()
            if isPerson {
                dataArray = [("发票抬头",model.invPayee),("联系人",model.invConsignee),("联系人邮箱",model.invEmail)]
                pleaceArray = ["请输入抬头","请输入联系人","请输入邮箱"]
            }else {
                dataArray = [("发票抬头",model.invPayee),("税号",model.invITIN),("联系人",model.invConsignee),("联系人邮箱",model.invEmail)]
                pleaceArray = ["请输入抬头","请输入税号","请输入联系人","请输入邮箱"]
            }
            tableView.reloadData()
        }
    }
    
    var dataArray:[(String,String)] = []
    
    var pleaceArray:[String] = ["请输入抬头","请输入联系人","请输入邮箱"]
    
    lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.tableHeaderView = tableHeadView()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ (m) in
            m.edges.equalTo(0)
        })
        let tap = UITapGestureRecognizer()
        tableView.addGestureRecognizer(tap)
        tap.rx.event.subscribe(onNext: { (tap) in
            tableView.endEditing(true)
        }).disposed(by: rx.disposeBag)
        return tableView
    }()
    
    lazy var tblFooter:UIView = {
        let v = UIView()
        v.backgroundColor = HEX("#F5F5F5")
        v.frame = CGRect.init(x: 0, y: self.view.qmui_height-44-cNaviTopHeight, width: self.view.qmui_width, height: 100)
        let quitBtn = QMUIButton()
        quitBtn.frame = CGRect.init(x: 20, y: 0, width: self.view.qmui_width-40, height: 44)
        quitBtn.setTitle("确定", for: .normal)
        quitBtn.setTitleColor(.white, for: .normal)
        quitBtn.titleLabel?.font = BoldFontSize(15)
        quitBtn.backgroundColor = HEX("#3890F9")
        v.addSubview(quitBtn)
        quitBtn.layer.cornerRadius = 22
        quitBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            guard let self = self else {return}
            if self.model.isInv {
                if self.isPerson {
                    if self.invPayee.value.isEmpty {
                        QMUITips.showError("请输入抬头")
                        return
                    }
                    if self.invConsignee.value.isEmpty {
                        QMUITips.showError("请输入联系人")
                        return
                    }
                    if self.invEmail.value.isEmpty {
                        QMUITips.showError("请输入邮箱")
                        return
                    }
                    
                    self.model.invPayee = self.invPayee.value
                    self.model.invConsignee = self.invConsignee.value
                    self.model.invEmail = self.invEmail.value
                }else {
                    if self.invPayee.value.isEmpty {
                        QMUITips.showError("请输入抬头")
                        return
                    }
                    if self.invITIN.value.isEmpty {
                        QMUITips.showError("请输入税号")
                        return
                    }
                    if self.invConsignee.value.isEmpty {
                        QMUITips.showError("请输入联系人")
                        return
                    }
                    if self.invEmail.value.isEmpty {
                        QMUITips.showError("请输入邮箱")
                        return
                    }
                    
                    self.model.invPayee = self.invPayee.value
                    self.model.invITIN = self.invITIN.value
                    self.model.invConsignee = self.invConsignee.value
                    self.model.invEmail = self.invEmail.value
                }
            }
            
            self.backInvoiceBlock(self.model)
            self.navigationController?.popViewController(animated: true)
           
        }).disposed(by: rx.disposeBag)
        
        return v
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView?.title = "发票信息"
        
        dataArray = [("发票抬头",model.invPayee),("联系人",model.invConsignee),("联系人邮箱",model.invEmail)]
        
        tableView.backgroundColor = HEX("#F9F9F9")
        view.addSubview(tblFooter)
        
        
    }
    

}


extension BKInvoceInfoVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:BKInvoceInfoCell! = tableView.dequeueReusableCell(withIdentifier: "cell") as? BKInvoceInfoCell
        if cell == nil {
            cell = BKInvoceInfoCell(style: .default, reuseIdentifier: "cell")
        }
        cell.selectionStyle = .none
        
        if isPerson {
            switch indexPath.row {
            case 0:
                invPayeeTF = cell.textField
                cell.textField.rx.text.orEmpty.bind(to: invPayee).disposed(by: cell.disposeBag)
            case 1:
                invConsigneeTF = cell.textField
                cell.textField.rx.text.orEmpty.bind(to: invConsignee).disposed(by: cell.disposeBag)
            case 2:
                invEmailTF = cell.textField
                cell.textField.rx.text.orEmpty.bind(to: invEmail).disposed(by: cell.disposeBag)
            default:
                break
            }
        }else {
            switch indexPath.row {
            case 0:
                invPayeeTF = cell.textField
                cell.textField.rx.text.orEmpty.bind(to: invPayee).disposed(by: cell.disposeBag)
            case 1:
                invITINTF = cell.textField
                cell.textField.rx.text.orEmpty.bind(to: invITIN).disposed(by: cell.disposeBag)
            case 2:
                invConsigneeTF = cell.textField
                cell.textField.rx.text.orEmpty.bind(to: invConsignee).disposed(by: cell.disposeBag)
            case 3:
                invEmailTF = cell.textField
                cell.textField.rx.text.orEmpty.bind(to: invEmail).disposed(by: cell.disposeBag)
            default:
                break
            }
        }
        
        
        
        cell.nameLabel.text = dataArray[indexPath.row].0
        cell.textField.placeholder = pleaceArray[indexPath.row]
        if model.isInv {
            cell.textField.text = dataArray[indexPath.row].1
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tableView.endEditing(true)
    }
    
    func tableHeadView() -> UIView {
        let head = BKInvoceView.loadNib()
        headView = head
        head.qmui_height = 88
        
        
        
//        head.needIncoveBtn.isSelected = self.model.isInv
//        head.noneedInvoceBtn.isSelected = !(self.model.isInv)
//
//        if model.invPayeeType == 1 {
//            head.personBtn.isSelected = true
//            head.composeBtn.isSelected = false
//            isPerson = true
//        }else {
//            head.personBtn.isSelected = false
//            head.composeBtn.isSelected = true
//            isPerson = false
//        }
        
        weak var weakHead : BKInvoceView? = head
        head.noneedInvoceBtn.rx.tap.subscribe(onNext: {[weak self] (tap) in
            weakHead?.noneedInvoceBtn.isSelected = true
            weakHead?.needIncoveBtn.isSelected = false
            self?.model.isInv = false
        }).disposed(by: rx.disposeBag)
        
        head.needIncoveBtn.rx.tap.subscribe(onNext: {[weak self] (tap) in
            weakHead?.noneedInvoceBtn.isSelected = false
            weakHead?.needIncoveBtn.isSelected = true
            self?.model.isInv = true
        }).disposed(by: rx.disposeBag)
        
        head.composeBtn.rx.tap.subscribe(onNext: {[weak self] (tap) in
            weakHead?.composeBtn.isSelected = true
            weakHead?.personBtn.isSelected = false
            self?.isPerson = false
            self?.model.invPayeeType = 2
            self?.invPayeeTF.text = ""
            self?.invITINTF.text = ""
            self?.invConsigneeTF.text = ""
            self?.invEmailTF.text = ""
        }).disposed(by: rx.disposeBag)
        
        head.personBtn.rx.tap.subscribe(onNext: {[weak self] (tap) in
            weakHead?.personBtn.isSelected = true
            weakHead?.composeBtn.isSelected = false
            self?.isPerson = true
            self?.model.invPayeeType = 1
            self?.invPayeeTF.text = ""
            self?.invITINTF.text = ""
            self?.invConsigneeTF.text = ""
            self?.invEmailTF.text = ""
        }).disposed(by: rx.disposeBag)
        return head
    }
    
}
