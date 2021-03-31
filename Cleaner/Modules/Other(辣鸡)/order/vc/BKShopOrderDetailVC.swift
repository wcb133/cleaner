//
//  BKShopOrderDetailVC.swift
//  BankeBus
//
//  Created by jemi on 2020/12/30.
//  Copyright © 2020 jemi. All rights reserved.
//

import QMUIKit

let imgHeight : CGFloat = 200
class BKShopOrderDetailVC: AppBaseVC {
    
    var orderNo = ""
    var model = BKShopOrderModel()
    
    var headView:BKShopOrderDetailHeadView?
    var footView:BKShopOrderDetailFootView?
    let imageView = UIImageView.init(frame: CGRect(x: 0, y: -imgHeight, width: cScreenWidth, height: imgHeight))
    
    
    lazy var sureBtn:QMUIButton = {
        let btn = QMUIButton()
        btn.setTitle("提醒卖家", for: .normal)
        btn.setTitleColor(HEX("#3890F9"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.layer.cornerRadius = 14.5
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = HEX("#3890F9").cgColor
        view.addSubview(btn)
        btn.snp.makeConstraints { (m) in
            m.trailing.equalTo(-12)
            m.top.equalTo(tableView.snp_bottom).offset(10)
            m.size.equalTo(CGSize(width: 86, height: 29))
        }
        return btn
    }()
    
    lazy var selectBtn:QMUIButton = {
        let btn = QMUIButton()
        btn.setTitle("申请退款", for: .normal)
        btn.setTitleColor(HEX("#333333"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.layer.cornerRadius = 14.5
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = HEX("#979797").cgColor
        view.addSubview(btn)
        btn.snp.makeConstraints { (m) in
            m.trailing.equalTo(sureBtn.snp_leading).offset(-12)
            m.centerY.size.equalTo(sureBtn)
        }
        return btn
    }()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.contentInset = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)
        
        imageView.backgroundColor = HEX("#3890F9")
        tableView.addSubview(imageView)
        tableView.rowHeight = 102
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.tableHeaderView = tableHeadView()
        tableView.tableFooterView = tableFootView()
        tableView.register(UINib(nibName: "\(BKShopOrderCell.self)", bundle: nil), forCellReuseIdentifier: ShopOrderCellID)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ (m) in
            m.bottom.equalTo(iPhoneX ? -69 : -49)
            m.top.equalTo(cStatusHeight)
            m.leading.trailing.equalTo(0)
        })
        return tableView
    }()
    
    override func preferredNavigationBarHidden() -> Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        titleView?.title = "商城订单"
        view.backgroundColor = HEX("#FFFFFF")
        tableView.backgroundColor = HEX("#F9F9F9")
        getData()
    }
    
    func setUp() {
        let tView = UIView(frame: CGRect(x: 0, y: 0, width: cScreenWidth, height: cStatusHeight))
        tView.backgroundColor = HEX("#3890F9")
        view.addSubview(tView)
        
        sureBtn.rx.tap.subscribe(onNext: {[weak self] (tap) in
            self?.sureBtnAction()
        }).disposed(by: rx.disposeBag)
        
        selectBtn.rx.tap.subscribe(onNext: {[weak self] (tap) in
            self?.selectBtnAction()
        }).disposed(by: rx.disposeBag)
    }
}


extension BKShopOrderDetailVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.goodsList.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShopOrderCellID, for: indexPath) as! BKShopOrderCell
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.bgView.cornerWith(byRoundingCorners: [.topLeft,.topRight], radii: 8)
        }else {
            cell.bgView.cornerWith(byRoundingCorners: [.topLeft,.topRight], radii: 0)
        }
        
       
        cell.statusNameLabel.isHidden = true
        cell.model = model.goodsList[indexPath.row]
        
        return cell
    }
    
    func tableHeadView() -> UIView {
        let head = BKShopOrderDetailHeadView(frame: CGRect(x: 0, y: 0, width: cScreenWidth, height: 166+87+87+12))
        headView = head
        return head
    }
    
    func tableFootView() -> UIView {
        let foot = BKShopOrderDetailFootView(frame: CGRect(x: 0, y: 0, width: cScreenWidth, height: 97+12+141+12+171+12))
        footView = foot
        return foot
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let offsetY  = scrollView.contentOffset.y
        let offsetH  = imgHeight + offsetY - 20
         
        if offsetH <= 0 {
            imageView.frame = CGRect(x: 0, y: -imgHeight+offsetH, width: cScreenWidth, height: imgHeight-offsetH)
            self.navigationController?.navigationBar.alpha = 0
        } else {
             
            let min = offsetH/(imgHeight-64) < 1 ? offsetH / (imgHeight-64) : 1
             
            self.navigationController?.navigationBar.alpha = min
        }
         
    }
    
    func loadBtnData(_ model:BKShopOrderModel) {
        selectBtn.isHidden = false
        sureBtn.isHidden = false
        sureBtn.layer.borderColor = HEX("#3890F9").cgColor
        sureBtn.setTitleColor(HEX("#3890F9"), for: .normal)
        switch model.state {
        case 1:
            selectBtn.setTitle("取消订单", for: .normal)
            sureBtn.setTitle("立即支付", for: .normal)
        case 2:
            selectBtn.setTitle("申请退款", for: .normal)
            sureBtn.setTitle("提醒卖家", for: .normal)
        case 3:
            selectBtn.setTitle("查看物流", for: .normal)
            sureBtn.setTitle("确定收货", for: .normal)
        case 4:
            selectBtn.setTitle("申请售后", for: .normal)
            sureBtn.setTitle("去评论", for: .normal)
        case 5:
            selectBtn.setTitle("申请售后", for: .normal)
            sureBtn.setTitle("去评论", for: .normal)
        case 6:
            selectBtn.isHidden = true
            sureBtn.setTitle("删除订单", for: .normal)
            sureBtn.setTitleColor(HEX("#333333"), for: .normal)
            sureBtn.layer.borderColor = HEX("#999999").cgColor
        case 7:
            selectBtn.isHidden = true
            sureBtn.setTitle("删除订单", for: .normal)
            sureBtn.setTitleColor(HEX("#333333"), for: .normal)
            sureBtn.layer.borderColor = HEX("#999999").cgColor
        case 9:
            selectBtn.setTitle("删除订单", for: .normal)
            sureBtn.setTitle("重新购买", for: .normal)
        case 100:
            selectBtn.isHidden = true
            sureBtn.setTitle("申请售后", for: .normal)
            sureBtn.setTitleColor(HEX("#333333"), for: .normal)
            sureBtn.layer.borderColor = HEX("#999999").cgColor
            
        default:
            break
        }
    }
    
    func selectBtnAction() {
        switch model.state {
        case 1:
            print("取消订单")
            cancleOrder()
        case 2:
//            let vc = BApplyAfterSaleVC()
//            vc.orderId = model.orderNo
//            vc.SaleState = .Bunds
//            vc.addressModel = model.addressModel
//            AppBaseNav.currentNavigationController()?.pushViewController(vc, animated: true)
        break
        case 3:
            print("查看物流")
            let vc = BKLogisticsInfoVC()
            vc.orderNo = model.orderNo
            AppBaseNav.currentNavigationController()?.pushViewController(vc, animated: true)
        case 4:
//            let vc = BApplyAfterSaleVC()
//            vc.orderId = model.orderNo
//            vc.SaleState = .Retrn
//            vc.addressModel = model.addressModel
//            AppBaseNav.currentNavigationController()?.pushViewController(vc, animated: true)
            break
        case 5:
//            let vc = BApplyAfterSaleVC()
//            vc.orderId = model.orderNo
//            vc.SaleState = .Retrn
//            vc.addressModel = model.addressModel
//            AppBaseNav.currentNavigationController()?.pushViewController(vc, animated: true)
            break
        case 7:
//            let vc = BApplyAfterSaleVC()
//            vc.orderId = model.orderNo
//            vc.SaleState = .Retrn
//            vc.addressModel = model.addressModel
//            AppBaseNav.currentNavigationController()?.pushViewController(vc, animated: true)
            break
        case 9:
            print("删除订单")
            deleteOrder()
            break
        case 100:
//            let vc = BApplyAfterSaleVC()
//            vc.orderId = model.orderNo
//            vc.SaleState = .Retrn
//            vc.addressModel = model.addressModel
//            AppBaseNav.currentNavigationController()?.pushViewController(vc, animated: true)
            break
            
        default:
            break
        }
    }
    
    func sureBtnAction() {
        switch model.state {
         case 1:
             print("付款")
            break
         case 2:
             QMUITips.showSucceed("已提醒卖家")
         case 3:
             //确认收货
             sureOrderData()
         case 4:
             //去评论
             let vc = BKShopOrderCommentVC()
             vc.model = model
             vc.refreshDataBlock = {[weak self] in
                self?.getData()
             }
             AppBaseNav.currentNavigationController()?.pushViewController(vc, animated: true)
         case 5:
             break
         case 6:
             print("删除订单")
             deleteOrder()
         case 7:
            deleteOrder()
        case 9:
            //重新购买
            postBuyAgainData()
        case 100:
            break
             
         default:
             break
         }
    }
    
}


extension BKShopOrderDetailVC {
    
    func getData() {
        QMUITips.showLoading(in: view)
        BKShopOrderModel.getOrderDetailData(orderNo) {[weak self] (model) in
            QMUITips.hideAllTips()
            self?.model = model
            self?.headView?.model = model
            self?.footView?.model = model
            self?.loadBtnData(model)
            self?.tableView.reloadData()
        }
    }
    
    //取消订单
    func cancleOrder() {}
    
    
    //删除订单
    func deleteOrder() {}
    
    
    func postBuyAgainData() {}
    
    
    //确认收货
    func sureOrderData() {
        BKOrderStatusNumModel.recieveOrderData(model.orderNo) {[weak self] (bool) in
            if (bool) {
                QMUITips.show(withText: "订单确认收货成功")
                self?.headView?.topView.time?.dispose()
                NotificationCenter.default.post(name: NSNotification.Name("ShopOrderRefresh"), object: nil)
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    
}
