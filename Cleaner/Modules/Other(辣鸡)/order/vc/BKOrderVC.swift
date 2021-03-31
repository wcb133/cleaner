//
//  BKOrderVC.swift
//  BankeBus
//
//  Created by jemi on 2020/12/2.
//  Copyright © 2020 jemi. All rights reserved.
//

import QMUIKit
import MJRefresh

class BKOrderVC: AppBaseVC {
    
    var orderStatus:BKOrderStatus = .all
    var OrderPayState = 0
    var dataArray:[BKOrderModel] = []
    var page = 1
    
    lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 278
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.register(UINib(nibName: "\(BKOrderCell.self)", bundle: nil), forCellReuseIdentifier: OrderCellID)
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
        
    NotificationCenter.default.rx.notification(NSNotification.Name("OrderRefresh")).subscribe(onNext: {[weak self] (notifi) in
            guard let self = self else {return}
            self.page = 1
            self.dataArray.removeAll()
            self.tableView.reloadData()
            self.getData()
        }).disposed(by: rx.disposeBag)
    }
    

}

extension BKOrderVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderCellID, for: indexPath) as! BKOrderCell
        cell.selectionStyle = .none
        cell.model = dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BKOrderDetailVC()
        let model = dataArray[indexPath.row]
        vc.orderId = model.id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    convenience init(_ status:BKOrderStatus) {
        self.init()
        self.orderStatus = status
        if status.rawValue == 1 {
            OrderPayState = 0
        }else if status.rawValue == 2 {
            OrderPayState = 2
        }else if status.rawValue == 0 {
            OrderPayState = 500
        }else if status.rawValue == 3 {
            OrderPayState = 1
        }else {
            OrderPayState = 3
        }
    }
    
    
    func setupEmptyView() {
        showEmptyView(with: UIImage(named: "order无内容"), text: "暂无订单", detailText: nil, buttonTitle: "", buttonAction: nil)
        emptyView?.imageViewInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        emptyView?.textLabelInsets = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        emptyView?.textLabelFont = .systemFont(ofSize: 13)
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


extension BKOrderVC {
    
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
        BKOrderModel.getOrderData(dic: ["pageIndex":page,"pageSize":10,"status":OrderPayState == 500 ? NSNull() : OrderPayState]) { (array) in
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


enum BKOrderStatus:Int {
    case all = 0    //所有
    case dispose = 1 //待处理
    case accept = 2  //已接受
    case refuse = 3 //已拒绝
    case complete = 4 //已完成
}
