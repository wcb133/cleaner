//
//  BKOrderDetailVC.swift
//  BankeBus
//
//  Created by jemi on 2020/12/2.
//  Copyright © 2020 jemi. All rights reserved.
//

import QMUIKit

class BKOrderDetailVC: AppBaseVC {
    
    var orderId = 0
    var model = BKOrderModel()
    var dataArray:[Array<(String,String,String,String,Bool)>] = []
    var nameArray:[(String,String,String,String,Bool)] = []
    var timeArray:[(String,String,String,String,Bool)] = []
    var timeArray1:[(String,String,String,String,Bool)] = []
    
    let refuseBtn = UIButton()
    let acceptBtn = UIButton()
    
    var isDidClickCheckBtn = false
    let head = BKDetialHeadSelectView.loadNib()
    var canBillingAgent = false
    var currentNum = 1
    
    lazy var bottomView:UIView = {
        let bottomV = tableFootView()
        view.addSubview(bottomV)
        bottomV.snp.makeConstraints { (m) in
            m.leading.trailing.equalToSuperview()
            m.bottom.equalTo(iPhoneX ? -20.0 : 0.0)
            m.height.equalTo(66)
        }
        return bottomV
    }()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.rowHeight = 46
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")

        
        tableView.register(UINib(nibName: "\(BKOrderDetailBottomCell.self)", bundle: nil), forCellReuseIdentifier: orderDetailBottomCellID)
        
        tableView.register(BKOrderDetailCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "\(BKOrderDetaiShowMoreCell.self)", bundle: nil), forCellReuseIdentifier: OrderDetaiShowMoreCellID)
        tableView.register(UINib(nibName: "\(BKOrderDetaiByPersonCell.self)", bundle: nil), forCellReuseIdentifier: OrderDetaiByPersonCellID)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ (m) in
            m.edges.equalTo(0)
        })
        return tableView
    }()
    
    lazy var invoiceView: BKOrderDetailInvoiceView = {
        let invoiceView = BKOrderDetailInvoiceView.loadNib()
        invoiceView.contentView.backgroundColor = HEX("#F5F5F5")
        weak var tmpInvoiceView = invoiceView
        invoiceView.addressChangeBlock = { [weak self] in
            guard let self = self else { return }
            guard let strongInvoiceView = tmpInvoiceView else { return }
            let province = strongInvoiceView.province
            let city = strongInvoiceView.city
            if province.isEmpty { return }
            self.getBillingFlowRequest(province: province, city: city)
        }
        invoiceView.invoiceTypeChangeBlock = {[weak self] in
            guard let self = self else { return }
            guard let strongInvoiceView = tmpInvoiceView else { return }
            self.tableView.reloadData()
            if strongInvoiceView.isBillingAgent {
                if self.dataArray.count > 1 {
                    self.dataArray.remove(at: 1)
                }
                self.dataArray.append(self.timeArray1)
                self.tableView.reloadData()
                self.refuseBtn.setTitle("拒绝", for: .normal)
                self.acceptBtn.setTitle("接受", for: .normal)
            }else{
                self.refuseBtn.setTitle("取消", for: .normal)
                self.acceptBtn.setTitle("确定", for: .normal)
            }
                
        }
        return invoiceView
    }()

    
    override func navigationBarShadowImage() -> UIImage? {
        return UIImage()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titleView?.title = "订单详情页"
        tableView.backgroundColor = .white
        getData()
        getNewOrderPeriodsData()
    }
    

}

extension BKOrderDetailVC:UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = dataArray[section]
        if section == 1 && model.status == 0 && !isDidClickCheckBtn && !self.invoiceView.isBillingAgent  {
            return 0
        }
        return arr.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 && model.status == 0 && !isDidClickCheckBtn {
            if self.invoiceView.isBillingAgent {
                return 70
            }
            return cScreenHeight - cNavigationHeight - (iPhoneX ? 86:66 )
        }
        
        
        if section == 0 {
            return 8
        }
        
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 && model.status == 0 && !isDidClickCheckBtn {
            return self.invoiceView
        }
            
        if section == 0 {
            let head = UIView(frame: CGRect(x: 0, y: 0, width: cScreenWidth, height: 8))
            head.backgroundColor = HEX("#F9F9F9")
            return head
        }
        
        weak var weakHead = head
        if model.status == 0  {
            
            if self.canBillingAgent {
                
                head.clickPersoBlock = {[weak self] num in
                    if self!.currentNum == num {return}
                    self?.currentNum = num
                    if num == 2 {
                        
                        self?.invoiceView.isBillingAgent = true
                        weakHead?.isSelectPersion = false
                        self?.model.canBillingAgent = true
                        if self!.dataArray.count > 1 {
                            self?.dataArray.remove(at: 1)
                        }
                        self?.dataArray.append(self!.timeArray1)
                        self?.tableView.reloadData()
                    }else {
                        self?.invoiceView.isBillingAgent = false
                        weakHead?.isSelectPersion = true
                        self?.model.canBillingAgent = false
                        if self!.dataArray.count > 1 {
                            self?.dataArray.remove(at: 1)
                        }
                        self?.dataArray.append(self!.timeArray)
                        self?.tableView.reloadData()
                    }
                }
                
                
            }else {
                head.comBtn.backgroundColor = HEX("#DADADA")
                head.comBtn.setTitleColor(HEX("#666666"), for: .normal)
                head.comBtn.layer.borderColor = UIColor.clear.cgColor
            }
        }else {

            if model.canBillingAgent {
                head.comBtn.backgroundColor = HEX("#3890F9")
                head.comBtn.setTitleColor(.white, for: .normal)
                head.comBtn.layer.borderColor = UIColor.clear.cgColor
                
                head.persionBtn.backgroundColor = HEX("#DADADA")
                head.persionBtn.setTitleColor(HEX("#666666"), for: .normal)
                head.persionBtn.layer.borderColor = UIColor.clear.cgColor
                
            }else {
               
                head.persionBtn.backgroundColor = HEX("#3890F9")
                head.persionBtn.setTitleColor(.white, for: .normal)
                head.persionBtn.layer.borderColor = UIColor.clear.cgColor
                
                head.comBtn.backgroundColor = HEX("#DADADA")
                head.comBtn.setTitleColor(HEX("#666666"), for: .normal)
                head.comBtn.layer.borderColor = UIColor.clear.cgColor
            }
        }
        
        head.showRedmeBlock = {
            let modalController = QMUIModalPresentationViewController()
            let tipView = BKShowReadMeInfoView.loadNib()
//            tipView.size = CGSize(width: 325, height: 320)
            modalController.contentView = tipView
            modalController.contentView = tipView
            modalController.animationStyle = .fade
            modalController.showWith(animated: true, completion: nil)
            tipView.closeBlock = {
                modalController.hideWith(animated: true, completion: nil)
            }
        }
        

        
        return head
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && model.status == 0 && !isDidClickCheckBtn {
            if self.invoiceView.isBillingAgent {
                let cell = tableView.dequeueReusableCell(withIdentifier: orderDetailBottomCellID) as! BKOrderDetailBottomCell
                cell.selectionStyle = .none

                cell.timeLabel.textColor = HEX("#666666")
                cell.pointLabel.textColor = HEX("#666666")
                cell.moneyLabel.textColor = HEX("#666666")
                
                cell.timeLabel.font = MediumFont(size: 13)
                cell.pointLabel.font = MediumFont(size: 13)
                cell.moneyLabel.font = MediumFont(size: 13)
                
                
                cell.timeLabel.text = dataArray[indexPath.section][indexPath.row].0
                cell.pointLabel.text = dataArray[indexPath.section][indexPath.row].2
                let title = dataArray[indexPath.section][indexPath.row].3
                cell.moneyLabel.text = title.replacingOccurrences(of: "已到账", with: "").replacingOccurrences(of: "未到账", with: "")
                
                if indexPath.row == 0 {
                    cell.timeLabel.textColor = HEX("#333333")
                    cell.pointLabel.textColor = HEX("#333333")
                    cell.moneyLabel.textColor = HEX("#333333")
                    
                    cell.timeLabel.font = UIFont.boldSystemFont(ofSize: 15)
                    cell.pointLabel.font = UIFont.boldSystemFont(ofSize: 15)
                    cell.moneyLabel.font = UIFont.boldSystemFont(ofSize: 15)
                    if model.status == 0 {
                        cell.timeLabel.text = "到账日期"
                        cell.pointLabel.text = "扣税金额"
                        cell.moneyLabel.text = "到账金额"
                    }
                }
                
                
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellID")!
            cell.selectionStyle = .none
            return cell
        }
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BKOrderDetailCell
            cell.selectionStyle = .none
            cell.line.isHidden = false
            cell.nameLabel.font = UIFont.systemFont(ofSize: 16)
            cell.valueLabel.font = UIFont.systemFont(ofSize: 16)
            cell.valueLabel.textColor = HEX("#333333")
            
            if indexPath.section == 0 && indexPath.row == nameArray.count - 1 {
                cell.line.isHidden = true
                if model.status == 0 {
                    cell.valueLabel.textColor = HEX("#C8B92A")
                }else if model.status == 1 {
                    cell.valueLabel.textColor = HEX("#DB3E8C")
                }else if model.status == 2 {
                    cell.valueLabel.textColor = HEX("#507FED")
                }else {
                    cell.valueLabel.textColor = HEX("#50C46E")
                }
                
            }
            
            if indexPath.section == 1 && indexPath.row == 0 {
                cell.nameLabel.font = MediumFont(size: 18)
                cell.valueLabel.font = MediumFont(size: 18)
            }
            cell.nameLabel.text = dataArray[indexPath.section][indexPath.row].0
            cell.valueLabel.text = dataArray[indexPath.section][indexPath.row].1
            return cell
        }else {
            
            if model.canBillingAgent {//企业代开
                let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetaiByPersonCellID, for: indexPath) as! BKOrderDetaiByPersonCell
                cell.selectionStyle = .none
                
                cell.timeLabel.textColor = HEX("#666666")
                cell.pointLabel.textColor = HEX("#666666")
                cell.moneyLabel.textColor = HEX("#666666")
                
                cell.timeLabel.font = MediumFont(size: 13)
                cell.pointLabel.font = MediumFont(size: 13)
                cell.moneyLabel.font = MediumFont(size: 13)
                
                
                cell.timeLabel.text = dataArray[indexPath.section][indexPath.row].0
                cell.pointLabel.text = dataArray[indexPath.section][indexPath.row].2
                
                if model.status >= 2 && indexPath.row > 0{
                    let title = dataArray[indexPath.section][indexPath.row].3
                    if dataArray[indexPath.section][indexPath.row].4 {
                        let attrTitle = NSMutableAttributedString.highText(title, highLight: "已到账", font: .boldSystemFont(ofSize: 13), color: HEX("#666666"), highLightColor: HEX("#50C46E"))
                        cell.moneyLabel.attributedText = attrTitle
                    }else {
                        let attrTitle = NSMutableAttributedString.highText(title, highLight: "未到账", font: .boldSystemFont(ofSize: 13), color: HEX("#666666"), highLightColor: HEX("#DB3E8C"))
                        cell.moneyLabel.attributedText = attrTitle
                    }
                    
                    
                }else {
                    cell.moneyLabel.text = dataArray[indexPath.section][indexPath.row].3
                }
                
                if indexPath.row == 0 {
                    cell.timeLabel.textColor = HEX("#333333")
                    cell.pointLabel.textColor = HEX("#333333")
                    cell.moneyLabel.textColor = HEX("#333333")
                    
                    cell.timeLabel.font = UIFont.boldSystemFont(ofSize: 15)
                    cell.pointLabel.font = UIFont.boldSystemFont(ofSize: 15)
                    cell.moneyLabel.font = UIFont.boldSystemFont(ofSize: 15)
                    if model.status == 0 {
                        cell.timeLabel.text = "到账日期"
                        cell.pointLabel.text = "扣税金额"
                        cell.moneyLabel.text = "到账金额"
                    }
                }
                
                
                return cell
            }else {//个人开票
                let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetaiShowMoreCellID, for: indexPath) as! BKOrderDetaiShowMoreCell
                cell.selectionStyle = .none
                
                cell.monthLabel.textColor = HEX("#666666")
                cell.moneyLabel.textColor = HEX("#666666")
                cell.pointLabel.textColor = HEX("#666666")
                cell.accetMoneyLabel.textColor = HEX("#666666")
                
                cell.monthLabel.font = MediumFont(size: 13)
                cell.moneyLabel.font = MediumFont(size: 13)
                cell.pointLabel.font = MediumFont(size: 13)
                cell.accetMoneyLabel.font = MediumFont(size: 13)
                
                
                cell.monthLabel.text = dataArray[indexPath.section][indexPath.row].0
                if indexPath.row > 0 {
//                    cell.monthLabel.text = dataArray[indexPath.section][indexPath.row].0.hc_dateFormater(fromDateFormat: "YYYY年MM月dd日", toDateFormat: "YYYY年MM月")
                }
                cell.moneyLabel.text = dataArray[indexPath.section][indexPath.row].1
                cell.pointLabel.text = dataArray[indexPath.section][indexPath.row].2
                
                if model.status >= 2 && indexPath.row > 0{
                    
                    let title = dataArray[indexPath.section][indexPath.row].3
                    if dataArray[indexPath.section][indexPath.row].4 {
                        let attrTitle = NSMutableAttributedString.highText(title, highLight: "已到账", font: .boldSystemFont(ofSize: 13), color: HEX("#666666"), highLightColor: HEX("#50C46E"))
                        cell.accetMoneyLabel.attributedText = attrTitle
                    }else {
                        let attrTitle = NSMutableAttributedString.highText(title, highLight: "未到账", font: .boldSystemFont(ofSize: 13), color: HEX("#666666"), highLightColor: HEX("#DB3E8C"))
                        cell.accetMoneyLabel.attributedText = attrTitle
                    }
                    
                    
                }else {
                    cell.accetMoneyLabel.text = dataArray[indexPath.section][indexPath.row].3
                }
                
                
                if indexPath.row == 0 {
                    cell.monthLabel.textColor = HEX("#333333")
                    cell.moneyLabel.textColor = HEX("#333333")
                    cell.pointLabel.textColor = HEX("#333333")
                    cell.accetMoneyLabel.textColor = HEX("#333333")
                    
                    cell.monthLabel.font = .boldSystemFont(ofSize: 15)
                    cell.moneyLabel.font = .boldSystemFont(ofSize: 15)
                    cell.pointLabel.font = .boldSystemFont(ofSize: 15)
                    cell.accetMoneyLabel.font = .boldSystemFont(ofSize: 15)
                    if model.status == 0 {
                        cell.monthLabel.text = "开票月份"
                        cell.moneyLabel.text = "开票金额"
                        cell.pointLabel.text = "预扣个税"
                        cell.accetMoneyLabel.text = "到账金额"
                    }
                }
                
                
                return cell
            }
        }
    }
    
    
    func tableFootView() -> UIView {
        let footV = UIView(frame: CGRect(x: 0, y: 0, width: cScreenWidth, height: 100))
        
        let line1 = UIView()
        line1.backgroundColor = HEX("#ECECEC")
        footV.addSubview(line1)
        line1.snp.makeConstraints { (m) in
            m.leading.top.trailing.equalToSuperview()
            m.height.equalTo(1)
        }
        
        let line = UIView()
        footV.addSubview(line)
        line.snp.makeConstraints { (m) in
            m.centerX.equalToSuperview()
            m.top.equalTo(48)
            m.size.equalTo(CGSize(width: 1, height: 40))
        }
        
        refuseBtn.setBackgroundImage(UIImage(named: "detail矩形备份"), for: .normal)
        refuseBtn.setTitle("取消", for: .normal)
        refuseBtn.setTitleColor(HEX("#FFFFFF"), for: .normal)
        refuseBtn.titleLabel?.font = MediumFont(size: 15)
        footV.addSubview(refuseBtn)
        refuseBtn.snp.makeConstraints { (m) in
            m.leading.equalTo(18)
            m.top.equalTo(12)
            m.trailing.equalTo(line.snp_leading).offset(-9)
            m.height.equalTo(40)
        }
        refuseBtn.rx.tap.subscribe(onNext: {[weak self] (tap) in
            guard let self = self else { return }
            if !self.isDidClickCheckBtn && !self.invoiceView.isBillingAgent {
                self.navigationController?.popViewController(animated: true)
            }else{
                self.refuseAction()
            }
            
        }).disposed(by: rx.disposeBag)
        
        
        acceptBtn.setBackgroundImage(UIImage(named: "detail矩形"), for: .normal)
        acceptBtn.setTitle("确定", for: .normal)
        acceptBtn.setTitleColor(HEX("#FFFFFF"), for: .normal)
        acceptBtn.titleLabel?.font = MediumFont(size: 15)
        footV.addSubview(acceptBtn)
        acceptBtn.snp.makeConstraints { (m) in
            m.trailing.equalTo(-18)
            m.leading.equalTo(line.snp_trailing).offset(9)
            m.top.height.equalTo(refuseBtn)
        }
        weak var tmpAcceptBtn = acceptBtn
        acceptBtn.rx.tap.subscribe(onNext: {[weak self] (tap) in
            guard let self = self else { return }
            if !self.isDidClickCheckBtn && !self.invoiceView.isBillingAgent {
                self.isDidClickCheckBtn = true
                self.head.isSelectPersion = true
                self.model.canBillingAgent = false
                tmpAcceptBtn?.setTitle("接受", for: .normal)
                self.refuseBtn.setTitle("拒绝", for: .normal)
                self.tableView.reloadData()
            }else{
                self.modifyOrderData(2)
            }
            
        }).disposed(by: rx.disposeBag)
        
        return footV
    }
    
    
    func refuseAction() {}
    
    
}

extension BKOrderDetailVC {
    

    func getData() {
        QMUITips.showLoading(in: view)
        BKOrderModel.getOrderDetailData(orderId) { (model) in
            
            self.model = model
            self.invoiceView.dataModel = model
            self.getBillingFlowRequest(province: model.businessCompany.cityValue.province, city: model.businessCompany.cityValue.city)
            self.nameArray.append(("订单编号",model.orderNo,"","",false))
            self.nameArray.append(("订单时间",model.auditValue.creationTime,"","",false))
            if model.status != 0 {
                self.nameArray.append(("确认时间",model.confirmTime,"","",false))
            }
            self.nameArray.append(("车辆",model.car.carValue.carNo,"","",false))
            self.nameArray.append(("租赁方式",model.payTypeName,"","",false))
            self.nameArray.append(("租赁金额",String(format: "%.2f元", model.rentAmount),"","",false))
            self.nameArray.append(("期数","\(model.period)","","",false))
//            self.nameArray.append(("租车日期",model.rent.startTime.hc_dateFormater(fromDateFormat: "yyyy-MM-dd HH:mm:ss", toDateFormat: "YYYY-MM-dd") + " 至 " + model.rent.endTime.hc_dateFormater(fromDateFormat: "yyyy-MM-dd HH:mm:ss", toDateFormat: "YYYY-MM-dd"),"","",false))
            self.nameArray.append(("订单状态",model.statusName,"","",false))
            self.canBillingAgent = model.canBillingAgent
            
            
            self.dataArray.append(self.nameArray)
            
            if model.status == 0 {
                self.bottomView.backgroundColor = .white
                self.tableView.snp.remakeConstraints { (m) in
                    m.leading.trailing.top.equalToSuperview()
                    m.bottom.equalTo(self.bottomView.snp_top)
                }
            }else {
                self.tableView.snp.remakeConstraints { (m) in
                    m.edges.equalToSuperview()
                }
            }
            
            if model.status == 0 {
                self.getOrderPeriodsData(false)
            }else {
                self.getOrderPeriodsData(model.canBillingAgent)
            }
            
            
        }
    }
    
    
    func getOrderPeriodsData(_ istrue:Bool) {
        BKOrderModel.getCarOwnerOrderPeriodsData(orderId,istrue) { (array) in
            
            let model = self.model
            
            if model.canBillingAgent {
                self.timeArray.append(("到账日期","","扣税金额","到账金额",false))
            }else {
                self.timeArray.append(("开票月份","开票金额","预扣个税","到账金额",false))
            }
            for item in array {
                var tax = item.tax
                if model.canBillingAgent {//企业代开
                    tax = item.tax + item.valueAddedAmount + item.additionalAmount
                }
                if model.status >= 2{
                    
                    
//                        self.timeArray.append((item.settlementDate.hc_dateFormater(fromDateFormat: "yyyy-MM-dd HH:mm:ss", toDateFormat: "YYYY年MM月dd日"),String(format: "%.2f", item.tax), (item.isPaid ? "已到账" : "未到账") + String(format: "   %.2f", item.amount),"",item.isPaid))
//                    }else {//个人开票
//                        self.timeArray.append((item.settlementDate.hc_dateFormater(fromDateFormat: "yyyy-MM-dd HH:mm:ss", toDateFormat: "YYYY年MM月dd日"),String(format: "%.2f", item.totalAmount),String(format: "%.2f", tax), (item.isPaid ? "已到账" : "未到账") + String(format: "   %.2f", item.amount),item.isPaid))
//                    }
                    
                }else {
//                    if model.canBillingAgent {//企业代开
//                        self.timeArray.append((item.settlementDate.hc_dateFormater(fromDateFormat: "yyyy-MM-dd HH:mm:ss", toDateFormat: "YYYY年MM月dd日"),String(format: "%.2f", item.tax),String(format: "%.2f", item.amount),"",false))
//                    }else {//个人开票
//                        self.timeArray.append((item.settlementDate.hc_dateFormater(fromDateFormat: "yyyy-MM-dd HH:mm:ss", toDateFormat: "YYYY年MM月dd日"),String(format: "%.2f", item.totalAmount),String(format: "%.2f", tax),String(format: "%.2f", item.amount),false))
//                    }
                    
                }
            }
            QMUITips.hideAllTips()
            self.dataArray.append(self.timeArray)
            self.tableView.reloadData()
            
        }
    }
    
    func getNewOrderPeriodsData() {
        BKOrderModel.getCarOwnerOrderPeriodsData(orderId,true) { (array) in
            let model = self.model
            self.timeArray1.append(("到账日期","","扣税金额","到账金额",false))
            
            for item in array {
                let tax = item.tax + item.valueAddedAmount + item.additionalAmount
                if model.status >= 2{
//                    if model.canBillingAgent {//企业代开
//                        self.timeArray.append((item.settlementDate.hc_dateFormater(fromDateFormat: "yyyy-MM-dd HH:mm:ss", toDateFormat: "YYYY年MM月dd日"),String(format: "%.2f", item.tax), (item.isPaid ? "已到账" : "未到账") + String(format: "   %.2f", item.amount),"",item.isPaid))
//                    }else {//个人开票
//                        self.timeArray1.append((item.settlementDate.hc_dateFormater(fromDateFormat: "yyyy-MM-dd HH:mm:ss", toDateFormat: "YYYY年MM月dd日"),String(format: "%.2f", item.totalAmount),String(format: "%.2f", tax), (item.isPaid ? "已到账" : "未到账") + String(format: "   %.2f", item.amount),item.isPaid))
////                    }
                    
                }else {
//                    if model.canBillingAgent {//企业代开
//                        self.timeArray.append((item.settlementDate.hc_dateFormater(fromDateFormat: "yyyy-MM-dd HH:mm:ss", toDateFormat: "YYYY年MM月dd日"),String(format: "%.2f", item.tax),String(format: "%.2f", item.amount),"",false))
//                    }else {//个人开票
//                        self.timeArray1.append((item.settlementDate.hc_dateFormater(fromDateFormat: "yyyy-MM-dd HH:mm:ss", toDateFormat: "YYYY年MM月dd日"),String(format: "%.2f", item.totalAmount),String(format: "%.2f", tax),String(format: "%.2f", item.amount),false))
//                    }
                    
                }
            }
            
        }
    }
    
    
    func modifyOrderData(_ status:Int) {
        
        BKOrderModel.updateOrderData(["carOrderId":orderId,"status":status,"canBillingAgent":self.invoiceView.isBillingAgent,"cityValue":["province":self.invoiceView.province,"city":self.invoiceView.city]]) { (bool) in
            if bool {
                NotificationCenter.default.post(name: NSNotification.Name("OrderRefresh"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }else {
                QMUITips.showError("失败")
            }
        }
    }
    
    //开票流程
    func getBillingFlowRequest(province:String,city:String) {
        
    }
    
    
}
