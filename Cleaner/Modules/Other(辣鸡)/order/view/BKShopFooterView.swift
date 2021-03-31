//
//  BKShopFooterView.swift
//  BankeBus
//
//  Created by jemi on 2020/12/29.
//  Copyright © 2020 jemi. All rights reserved.
//

import UIKit
import RxSwift

let BKShopFooterViewID = "BKShopFooterViewID"
class BKShopFooterView: UITableViewHeaderFooterView,LoadNibable {

    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var payLabel: UILabel!
    
    @IBOutlet weak var payNameLabel: UILabel!
    @IBOutlet weak var sureBtn: UIButton!
    
    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    
    var disposeBag = DisposeBag()
    
    var model = BKShopOrderModel() {
        didSet{
            totalLabel.text = String(format: "%.2f", model.amount + model.freightAmount)
            if model.state == 1 || model.state == 9{
                payNameLabel.text = "待付款"
            }else {
                payNameLabel.text = "实付款"
            }
            payLabel.text = String(format: "%.2f", model.amount + model.freightAmount)
            
            ///未知=0,未支付=1,已支付=2,已发货=3,已经签收=4,部分退款=5,已退款=7,已取消=9,完成=100,删除=1000
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
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sureBtn.layer.cornerRadius = 14.5
        sureBtn.layer.masksToBounds = true
        sureBtn.layer.borderWidth = 1
        sureBtn.layer.borderColor = HEX("#3890F9").cgColor
        selectBtn.layer.cornerRadius = 14.5
        selectBtn.layer.masksToBounds = true
        selectBtn.layer.borderWidth = 1
        selectBtn.layer.borderColor = HEX("#999999").cgColor
        
        bgView.cornerWith(byRoundingCorners: [.bottomLeft,.bottomRight], radii: 8)
    }
    
    //单元格重用时调用
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        bgView.cornerWith(byRoundingCorners: [.bottomLeft,.bottomRight], radii: 8)
    }
    
    
    @IBAction func selectAction(_ sender: Any) {
        switch model.state {
        case 1:
            print("取消订单")
            cancleOrder()
            break
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
            break
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
        case 100:
            break
//            let vc = BApplyAfterSaleVC()
//            vc.orderId = model.orderNo
//            vc.SaleState = .Retrn
//            vc.addressModel = model.addressModel
//            AppBaseNav.currentNavigationController()?.pushViewController(vc, animated: true)
            
        default:
            break
        }
    }
    
    @IBAction func sureAction(_ sender: Any) {
        switch model.state {
         case 1:
             print("付款")
//            let vc = BKOrderPayVC()
//             let m = BKCommitOrderResultModel()
//             m.orderNo = model.orderNo
//             m.closeOrderTime = model.closeOrderTime
//             vc.resultModel = m
//             vc.totalMoney = "\(model.payAmount)"
//            AppBaseNav.currentNavigationController()?.pushViewController(vc, animated: true)
         case 2:
            QMUITips.showSucceed("已提醒卖家")
         case 3:
             //确认收货
             sureOrderData()
         case 4:
             //去评论
             let vc = BKShopOrderCommentVC()
             vc.model = model
             AppBaseNav.currentNavigationController()?.pushViewController(vc, animated: true)
         case 5:
             break
         case 6:
            deleteOrder()
         case 7:
            deleteOrder()
        case 9:
            //重新购买
            postBuyAgainData()
        case 100:
//             let vc = BApplyAfterSaleVC()
//             vc.orderId = model.orderNo
//             vc.SaleState = .Retrn
//             vc.addressModel = model.addressModel
//             AppBaseNav.currentNavigationController()?.pushViewController(vc, animated: true)
            break
         default:
             break
         }
    }
}


extension BKShopFooterView {
    //取消订单
    func cancleOrder() {
        
//        let tipView = ChargeNoMoneyTipView.loadNib()
//        tipView.frame = CGRect(x: 0, y: 0, width: cScreenWidth-50, height: 155)
//
//        tipView.tipLabel.text = "是否取消订单"
//        tipView.tipLabel.font = BoldFontSize(18)
//        tipView.tipLabel.textColor = HEX("#333333")
//        tipView.cancleBtn.setTitle("取消", for: .normal)
//        tipView.confirmBtn.setTitle("确定", for: .normal)
//        tipView.confirmBtn.setTitleColor(HEX("#3890F9"), for: .normal)
//
//
//        let diagVC = QMUIDialogViewController()
//        diagVC.headerViewHeight = 0.1
//        diagVC.footerViewHeight = 0.1
//        diagVC.contentView = tipView
//        diagVC.show()
//
//        tipView.cancleBtn.rx.tap.subscribe(onNext: {
//            diagVC.hide()
//        }).disposed(by: disposeBag)
//
//        tipView.confirmBtn.rx.tap.subscribe(onNext: {
//            diagVC.hide()
//            BKOrderStatusNumModel.closeOrderData(self.model.orderNo) { (bool) in
//                if (bool) {
//                    QMUITips.show(withText: "订单已取消")
//                    NotificationCenter.default.post(name: NSNotification.Name("ShopOrderRefresh"), object: nil)
//                }
//            }
//        }).disposed(by: disposeBag)
        
    }
    
    
    //删除订单
    func deleteOrder() {
        
//        let tipView = ChargeNoMoneyTipView.loadNib()
//        tipView.frame = CGRect(x: 0, y: 0, width: cScreenWidth-50, height: 155)
//
//        tipView.tipLabel.text = "是否删除订单"
//        tipView.tipLabel.font = BoldFontSize(18)
//        tipView.tipLabel.textColor = HEX("#333333")
//        tipView.cancleBtn.setTitle("取消", for: .normal)
//        tipView.confirmBtn.setTitle("确定", for: .normal)
//        tipView.confirmBtn.setTitleColor(HEX("#3890F9"), for: .normal)
//
//
//        let diagVC = QMUIDialogViewController()
//        diagVC.headerViewHeight = 0.1
//        diagVC.footerViewHeight = 0.1
//        diagVC.contentView = tipView
//        diagVC.show()
//
//        tipView.cancleBtn.rx.tap.subscribe(onNext: {
//            diagVC.hide()
//        }).disposed(by: disposeBag)
//
//        tipView.confirmBtn.rx.tap.subscribe(onNext: {
//            diagVC.hide()
//            BKOrderStatusNumModel.removeOrderData(self.model.orderNo) { (bool) in
//                if (bool) {
//                    QMUITips.show(withText: "订单已删除")
//                    NotificationCenter.default.post(name: NSNotification.Name("ShopOrderRefresh"), object: nil)
//                }
//            }
//        }).disposed(by: disposeBag)
  
    }
    
    //确认收货
    func sureOrderData() {
        BKOrderStatusNumModel.recieveOrderData(model.orderNo) { (bool) in
            if (bool) {
                QMUITips.show(withText: "订单确认收货成功")
                NotificationCenter.default.post(name: NSNotification.Name("ShopOrderRefresh"), object: nil)
            }
        }
    }
    
    //重新购买
    func postBuyAgainData() {
        QMUITips.showLoading(in: cKeyWindow!)
        GoodsOrderModel.getShopOrderGoodsData(model.orderNo) { (array) in
            QMUITips.hideAllTips()
            if array.count > 0 {
//                let vc = BKCommitOrderVC()
//                for goods in array {
//                    let item = BShopCarModel()
//                    item.goodsId = goods.goodsId
//                    item.name = goods.goodsName
//                    item.imageUrl = goods.goodsImageUrl
//                    item.price = CGFloat(goods.goodsPrice)
//                    item.number = goods.number
//                    item.freightTemplateId = goods.templateId
//
//                    for m in goods.attributes {
//                        item.goodsAttributeParameters.append(JsonUtil.modelToDictionary(m))
//                    }
//                    vc.itemDatas.append(item)
//                }
//
//                AppBaseNav.currentNavigationController()?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func payOrderData() {
        BKOrderStatusNumModel.getOrderPayData(["orderNo":model.orderNo,"payType":""]) { (model) in
            
        }
    }
    
}
