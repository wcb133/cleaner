//
//  BKShopCommentView.swift
//  BankeBus
//
//  Created by jemi on 2021/1/7.
//  Copyright © 2021 jemi. All rights reserved.
//

import UIKit

class BKShopCommentView: UIView {
    
    let headView = BKShopCommentHeadView.loadNib()
    let inputsView = BKCommentInputView.loadNib()
    let bgView = UIScrollView()
    let sureBtn = QMUIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
    }
    
    func loadUI() {
        addSubview(bgView)
        bgView.snp.makeConstraints { (m) in
            m.leading.top.equalToSuperview()
            m.width.equalTo(cScreenWidth)
            m.bottom.equalTo(iPhoneX ? -32-39 : -12-39)
        }
        let tap = UITapGestureRecognizer()
        bgView.addGestureRecognizer(tap)
        tap.rx.event.subscribe(onNext: {[weak self] (tap) in
            self?.endEditing(true)
        }).disposed(by: rx.disposeBag)
        
        bgView.addSubview(headView)
        headView.snp.makeConstraints { (m) in
            m.leading.top.width.equalToSuperview()
            m.height.equalTo(247)
        }
        
        
        bgView.addSubview(inputsView)
        inputsView.snp.makeConstraints { (m) in
            m.leading.equalTo(0)
            m.top.equalTo(headView.snp_bottom)
            m.width.equalTo(cScreenWidth)
            m.height.equalTo(181)
        }
        
        sureBtn.setTitle("提交评价", for: .normal)
        sureBtn.setTitleColor(.white, for: .normal)
        sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        sureBtn.backgroundColor = HEX("#3890F9")
        sureBtn.layer.cornerRadius = 19.5
        sureBtn.layer.masksToBounds = true
        addSubview(sureBtn)
        sureBtn.snp.makeConstraints { (m) in
            m.leading.equalTo(18)
            m.bottom.equalTo(iPhoneX ? -32 : -12)
            m.size.equalTo(CGSize(width: cScreenWidth-36, height: 39))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
