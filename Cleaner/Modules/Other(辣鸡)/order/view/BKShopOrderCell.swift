//
//  BKShopOrderCell.swift
//  BankeBus
//
//  Created by jemi on 2020/12/29.
//  Copyright © 2020 jemi. All rights reserved.
//

import UIKit

let ShopOrderCellID = "ShopOrderCellID"
class BKShopOrderCell: UITableViewCell,LoadNibable {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var shopImg: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var numLabel: UILabel!
    
    @IBOutlet weak var tagLabel: UILabel!
    
    @IBOutlet weak var statusNameLabel: UILabel!
    
    
    var model = BKGoodsModel() {
        didSet {
//            shopImg.kf.setImage(with: URL(string: model.goodsImageUrl), placeholder: UIImage(named: "商品缺省图"), options: nil, progressBlock: nil, completionHandler: nil)
            nameLabel.text = model.goodsName
            priceLabel.text = String(format: "%.2f", model.goodsPrice)
            numLabel.text = "x\(model.goodsNumber)"
            tagLabel.text = model.sku
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = HEX("#F9F9F9")
        contentView.backgroundColor = HEX("#F9F9F9")
        shopImg.image = UIImage(named: "商品缺省图")
       
    }
    
    

}
