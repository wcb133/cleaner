//
//  BKShopOrderVC.swift
//  BankeBus
//
//  Created by jemi on 2020/12/29.
//  Copyright © 2020 jemi. All rights reserved.
//

import QMUIKit
import MJRefresh

class BKShopOrderVC: AppBaseVC {
    
    var orderStatus:BKOrderStatus = .all
    var OrderPayState = 0
    var dataArray:[BKShopOrderModel] = []
    var page = 1
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = 102
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.register(UINib(nibName: "\(BKShopOrderCell.self)", bundle: nil), forCellReuseIdentifier: ShopOrderCellID)
        tableView.register(UINib(nibName: "\(BKShopFooterView.self)", bundle: nil), forHeaderFooterViewReuseIdentifier: BKShopFooterViewID)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ (m) in
            m.top.equalTo(15)
            m.leading.trailing.bottom.equalTo(0)
        })
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = HEX("#F9F9F9")
        tableView.backgroundColor = HEX("#F9F9F9")
        addRefresh()
        setupEmptyView()
        getData()
        
        
        NotificationCenter.default.rx.notification(NSNotification.Name("ShopOrderRefresh")).subscribe(onNext: {[weak self] (notifi) in
            guard let self = self else {return}
            self.page = 1
            self.dataArray.removeAll()
            self.tableView.reloadData()
            self.getData()
        }).disposed(by: rx.disposeBag)
        
        
    }
    
    ///刷新
    func addRefresh() {
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            self?.page = 1
            self?.dataArray.removeAll()
            self?.tableView.reloadData()
            self?.getData()
        })
        
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
            self?.page += 1
            self?.getData()
        })
        footer.setTitle("到底了~", for: .noMoreData)
        footer.setTitle("", for: .idle)
        footer.stateLabel?.textColor = UIColor.qmui_color(withHexString: "#999999")
        footer.stateLabel?.font = UIFont.systemFont(ofSize: 12)
        tableView.mj_footer = footer
    }
    
    func getData() {
        BKShopOrderModel.getShopOrderData(dic: ["State":OrderPayState,"PageIndex":page,"PageSize":10]) { (array) in
            
            for item in array {
                item.addressModel.consignee = item.consignee
                item.addressModel.mobile = item.mobile
                item.addressModel.address = item.address
            }
            
            self.dataArray.append(contentsOf: array)
            if self.dataArray.count == 0 {
                self.showEmptyView()
            }else {
                self.hideEmptyView()
            }
            self.tableView.reloadData()
            self.tableView.mj_header?.endRefreshing()
            if array.count == 0 && self.dataArray.count != 0 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }else {
                self.tableView.mj_footer?.endRefreshing()
            }
        }
    }
}


extension BKShopOrderVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = dataArray[section]
        return model.goodsList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let foot = tableView.dequeueReusableHeaderFooterView(withIdentifier: BKShopFooterViewID) as! BKShopFooterView
        let model = dataArray[section]
        foot.model = model
        
        let tap = UITapGestureRecognizer()
        foot.addGestureRecognizer(tap)
        tap.rx.event.subscribe(onNext: {[weak self] (tap) in
            let vc = BKShopOrderDetailVC()
            let model = self!.dataArray[section]
            vc.orderNo = model.orderNo
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: foot.disposeBag)
        return foot
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 106
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShopOrderCellID, for: indexPath) as! BKShopOrderCell
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.bgView.cornerWith(byRoundingCorners: [.topLeft,.topRight], radii: 8)
        }else {
            cell.bgView.cornerWith(byRoundingCorners: [.topLeft,.topRight], radii: 0)
        }
        
        let model = dataArray[indexPath.section]
        setupStatusName(model,cell.statusNameLabel)
        cell.model = model.goodsList[indexPath.row]
        if indexPath.row == model.goodsList.count - 1{
            cell.statusNameLabel.isHidden = false
        }else {
            cell.statusNameLabel.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = BKShopOrderDetailVC()
        let model = dataArray[indexPath.section]
        vc.orderNo = model.orderNo
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    convenience init(_ status:BKOrderStatus) {
        self.init()
        self.orderStatus = status
        OrderPayState = status.rawValue
//        if status.rawValue == 1 {
//            OrderPayState = 1
//        }else if status.rawValue == 2 {
//            OrderPayState = 2
//        }else if status.rawValue == 0 {
//            OrderPayState = 0
//        }else if status.rawValue == 3 {
//            OrderPayState = 3
//        }else {
//            OrderPayState = 4
//        }
    }
    
    
    func setupEmptyView() {
        showEmptyView(with: UIImage(named: "无订单图"), text: "暂无订单信息", detailText: nil, buttonTitle: "", buttonAction: nil)
        emptyView?.imageViewInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        emptyView?.textLabelInsets = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        emptyView?.textLabelFont = MediumFont(size: 13)
        emptyView?.textLabelTextColor = HEX("#999999")
        emptyView?.verticalOffset = -50
        hideEmptyView()
    }
    
    override func showEmptyView() {
        if emptyView == nil {
            emptyView = QMUIEmptyView(frame: tableView.bounds)
        }
        tableView.addSubview(emptyView!)
        emptyView?.frame = CGRect(x: 0, y: 0, width: cScreenWidth, height: view.qmui_height)
    }
    
}


extension BKShopOrderVC{
    ///未知=0,未支付=1,已支付=2,已发货=3,已经签收=4,部分退款=5,已退款=7,已取消=9,完成=100,删除=1000
    func setupStatusName(_ model:BKShopOrderModel,_ label:UILabel) {
           switch model.state {
           case 1:
               label.text = "订单未支付"
           case 2:
               label.text = "待卖家发货"
           case 3:
               label.text = "卖家已发货"
           case 4:
               label.text = "交易完成"
           case 6:
               label.text = "交易关闭"
           case 7:
               label.text = "交易关闭"
           case 9:
               label.text = "订单已关闭"
           case 100:
               label.text = "交易完成"
               
           default:
               label.text = "交易完成"
           }
       }
    
}
