//
//  PhotoAndVideoClearCell.swift
//  Cleaner
//
//  Created by fst on 2021/3/21.
//

import UIKit

let photoAndVideoClearCellID = "PhotoAndVideoClearCell"
class PhotoAndVideoClearCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var selectBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func selectBtnAction(_ sender: UIButton) {
    }
    

}
