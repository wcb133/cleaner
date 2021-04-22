//
//  PhotoAndVideoClearCell.swift
//  Cleaner
//
//  Created by fst on 2021/3/21.
//

import UIKit

let photoAndVideoClearCellID = "PhotoAndVideoClearCell"
class ImageAndVideoDealCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var selectBtn: UIButton!
    
    
    @IBOutlet weak var playIcon: UIImageView!
    
    var selectBtnActionBlock:()->Void = {}
    
    var item:ImageModel? {
        didSet{
            guard let model = self.item else { return }
            self.playIcon.isHidden = true
            self.imgView.image = model.exactImage
            self.selectBtn.isSelected = model.isSelect
        }
    }
    
    var videoItem:VideoModel?{
        didSet{
            guard let videoItem = self.videoItem else { return }
            self.playIcon.isHidden = false
            self.imgView.image = videoItem.exactImage
            self.selectBtn.isSelected = videoItem.isSelect
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func selectBtnAction(_ sender: UIButton) {
        self.selectBtnActionBlock()
    }
    

}
