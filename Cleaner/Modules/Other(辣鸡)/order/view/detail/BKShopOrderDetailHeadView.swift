//
//  BKShopOrderDetailHeadView.swift
//  BankeBus
//
//  Created by jemi on 2020/12/31.
//  Copyright © 2020 jemi. All rights reserved.
//

import UIKit

class BKShopOrderDetailHeadView: UIView {
    //最顶部蓝色部分
    let topView = BKOrderDetailBlueHeadView.loadNib()
    //物流部分
    let logisticsView = BKLogisticsView.loadNib()
    //收货地址
    let addressView = BKRecevieAddressView.loadNib()
    
    var model = BKShopOrderModel() {
        didSet{
            logisticsView.isHidden = false
            topView.model = model
            logisticsView.model = model.logisticsModel
            addressView.model = model.addressModel
            if model.state == 1 || model.state == 9 {
                self.qmui_height = 166+87+12
                logisticsView.snp.updateConstraints { (m) in
                    m.top.equalTo(topView.snp_bottom).offset(0)
                    m.height.equalTo(0)
                }
            }else {
                logisticsView.nameLabel.numberOfLines = model.logisticsModel.isFinish ? 2 : 1
                let hei:CGFloat = model.logisticsModel.isFinish ? 15 : 0
                self.qmui_height = 166 + 87 + 87 + 12 + hei
                logisticsView.snp.updateConstraints { (m) in
                    m.top.equalTo(topView.snp_bottom).offset(12)
                    m.height.equalTo(75 + hei)
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
    }
    
    func loadUI() {
        backgroundColor = HEX("#F9F9F9")
        addSubview(topView)
        topView.snp.makeConstraints { (m) in
            m.leading.top.trailing.equalToSuperview()
            m.height.equalTo(166)
        }
        
        addSubview(logisticsView)
        logisticsView.isHidden = true
        logisticsView.snp.makeConstraints { (m) in
            m.top.equalTo(topView.snp_bottom).offset(12)
            m.leading.equalTo(12)
//            m.width.equalTo(width-24)
            m.height.equalTo(75)
        }
        let tap = UITapGestureRecognizer()
        logisticsView.addGestureRecognizer(tap)
        tap.rx.event.subscribe(onNext: {[weak self] (tap) in
            let vc = BKLogisticsInfoVC()
            vc.orderNo = self!.model.orderNo
            AppBaseNav.currentNavigationController()?.pushViewController(vc, animated: true)
        }).disposed(by: rx.disposeBag)
        
        addSubview(addressView)
        addressView.snp.makeConstraints { (m) in
            m.top.equalTo(logisticsView.snp_bottom).offset(12)
            m.leading.equalTo(12)
//            m.width.equalTo(width-24)
            m.height.equalTo(75)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
