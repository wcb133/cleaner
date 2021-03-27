//
//  AllScanCell.swift
//  Cleaner
//
//  Created by fst on 2021/3/23.
//

import UIKit


let allScanCellID = "allScanCellID"
class AllScanCell: UITableViewCell {

    @IBOutlet weak var mainLab: UILabel!
    
    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var subTitleLab: UILabel!
    
    @IBOutlet weak var arrowIcon: UIImageView!
    
    
    @IBOutlet weak var bgView: UIView!
    
    var selectBtnClickBlock:()->Void = {}
    
    let indicatorView = UIActivityIndicatorView(style: .gray)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        bgView.layer.cornerRadius = 16
        
        indicatorView.startAnimating()
        indicatorView.hidesWhenStopped = true
        self.contentView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { (m) in
            m.left.right.top.bottom.equalTo(selectBtn)
        }

        bgView.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowRadius = 5
        bgView.layer.shadowOpacity = 0.2
        
        self.selectBtn.addTarget(self, action: #selector(selectBtnAction), for: .touchUpInside)
    }
    
    @objc func selectBtnAction(btn:UIButton) {
        btn.isSelected = !btn.isSelected
        selectBtnClickBlock()
    }
    
    var dataModel = AllScanModel(){
        didSet{
            self.selectBtn.isSelected = dataModel.isSelect
            if dataModel.isDidCheck {
                self.selectBtn.isHidden = false
                self.arrowIcon.isHidden = false
                self.indicatorView.stopAnimating()
                self.titleLab.isHidden = false
                self.subTitleLab.isHidden = false
                self.mainLab.isHidden = true
                self.titleLab.text = dataModel.title
                self.subTitleLab.text = dataModel.subTitle
            }else{
                self.selectBtn.isHidden = true
                self.indicatorView.startAnimating()
                self.arrowIcon.isHidden = true
                self.titleLab.isHidden = true
                self.subTitleLab.isHidden = true
                self.mainLab.isHidden = false
                self.mainLab.text = dataModel.title
            }
        }
    }
    
}
