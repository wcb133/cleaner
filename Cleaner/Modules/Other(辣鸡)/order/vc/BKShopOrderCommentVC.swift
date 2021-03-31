//
//  BKShopOrderCommentVC.swift
//  BankeBus
//
//  Created by jemi on 2021/1/7.
//  Copyright © 2021 jemi. All rights reserved.
//

import UIKit

class BKShopOrderCommentVC: AppBaseVC {
    
    var imgUrlArray:[String] = []
    var model = BKShopOrderModel()
    var refreshDataBlock:(()->Void) = {}
    
    lazy var commentView : BKShopCommentView = {
        let comment = BKShopCommentView()
        view.addSubview(comment)
        comment.snp.makeConstraints { (m) in
            m.top.equalTo(12)
            m.leading.trailing.bottom.equalToSuperview()
        }
        return comment
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView?.title = "订单评价"
        view.backgroundColor = HEX("#F9F9F9")
//        commentView.headView.img.kf.setImage(with: URL(string: model.goodsList.first?.goodsImageUrl ?? ""), placeholder: UIImage(named: "商品缺省图"), options: nil, progressBlock: nil, completionHandler: nil)
//        commentView.headView.nameLabel.text = model.goodsList.first?.goodsName
        commentView.backgroundColor = .white
        commentView.sureBtn.rx.tap.subscribe(onNext: {[weak self] (tap) in
            
//            if self!.commentView.headView.star1?.currentStarCount == 0 {
//                QMUITips.showError("请对商品质量星级评价")
//                return
//            }
//
//            if self!.commentView.headView.star2?.currentStarCount == 0 {
//                QMUITips.showError("请对服务态度星级评价")
//                return
//            }
//
//            if self!.commentView.headView.star3?.currentStarCount == 0 {
//                QMUITips.showError("请对物流星级评价")
//                return
//            }
            
            if self!.commentView.inputsView.textView.text.isEmpty {
                QMUITips.showError("请填写评论，不少于8个字")
                return
            }
            
            if self?.commentView.inputsView.imgArray.count == 0 {
                //无图
                self?.postCommentData()
            }else {
                //有图
                self?.queueGroup()
            }
        }).disposed(by: rx.disposeBag)
    }
    
    
    
}

extension BKShopOrderCommentVC {
    
    func queueGroup() {
        
        let imgArr = commentView.inputsView.imgArray
        
        //创建队列组
        let group = DispatchGroup()
        //创建并发队列
        let queue = DispatchQueue.global()
        QMUITips.showLoading(in: self.view)
        
        for (index,item) in imgArr.enumerated() {
            queue.async(group: group, execute: {
                //任务1
                group.enter()
                self.uploadFileData(item, index, group)
            })
        }
        
        group.notify(queue: queue) {
            DispatchQueue.main.async {
                //任务3
                QMUITips.hideAllTips()
                if self.imgUrlArray.count != imgArr.count {
                    QMUITips.showError("添加失败")
                    self.imgUrlArray.removeAll()
                }else {
                    //提交评论数据
                    self.postCommentData()
                }
                
            }
        }
        
    }
    
    
    func uploadFileData(_ img:UIImage, _ index:Int, _ group:DispatchGroup) {}
    
    func postCommentData() {
        
        let parame:[String:Any] = [:]
        BKOrderStatusNumModel.addOrderCommentData(parame) { (bool) in
            if bool {
                QMUITips.show(withText: "评论成功")
                NotificationCenter.default.post(name: NSNotification.Name("ShopOrderRefresh"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }else {
                QMUITips.showError("评论失败")
            }
        }
    }
    
    
    
}
