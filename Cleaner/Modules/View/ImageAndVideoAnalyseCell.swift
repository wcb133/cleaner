//
//  PhotoAndVideoScanCell.swift
//  Cleaner
//
//  Created by fst on 2021/3/22.
//

import UIKit

let photoAndVideoScanCellID = "photoAndVideoScanCellID"
class ImageAndVideoAnalyseCell: UITableViewCell {
    
    
    @IBOutlet weak var mainLab: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var subTitleLab: UILabel!
    
    @IBOutlet weak var arrowIcon: UIImageView!
    //    let w:CGFloat = 50
//
//    let kAnimationDuration:Double = 0.9
//
//    let containerLayer = CAReplicatorLayer()
//    let subLayer = CALayer()
    
    let indicatorView = UIActivityIndicatorView(style: .gray)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        indicatorView.startAnimating()
        indicatorView.hidesWhenStopped = true
        self.contentView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { (m) in
            m.right.equalTo(-20)
            m.centerY.equalToSuperview()
         }
        
    
//        containerLayer.masksToBounds = true
//        containerLayer.instanceCount = 12;
//        containerLayer.instanceDelay = kAnimationDuration / Double(containerLayer.instanceCount)
//        let angle = 360.0 / Double(containerLayer.instanceCount) * .pi / 180.0
//        containerLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0, 0, 1)
//        containerLayer.frame = CGRect(x: cScreenWidth - 50.0 - 20.0, y: (65 - w) * 0.5 , width: w, height: w)
//        self.layer.addSublayer(containerLayer)

        
//        subLayer.backgroundColor = UIColor.red.cgColor
//        subLayer.frame = CGRect(x: 0, y: 0 , width: w, height: w)
//        subLayer.cornerRadius = w * 0.5
//        subLayer.transform = CATransform3DMakeScale(0, 0, 0)
//        containerLayer.addSublayer(subLayer)
//        let animation = CABasicAnimation(keyPath: "transform.scale")
//        animation.fromValue = 1
//        animation.toValue = 0.1
//        animation.repeatCount = HUGE
//        animation.duration = kAnimationDuration
//        subLayer.add(animation, forKey: nil)
    
    }

    var dataModel = ImageAndVideoAnalyseModel(){
        didSet{
            self.icon.image = UIImage(named: dataModel.icon)
            if dataModel.isDidCheck {
                self.arrowIcon.isHidden = false
                self.indicatorView.stopAnimating()
                self.titleLab.isHidden = false
                self.subTitleLab.isHidden = false
                self.mainLab.isHidden = true
                self.titleLab.text = localizedString(dataModel.title)
                self.subTitleLab.text = dataModel.subTitle
            }else{
                self.indicatorView.startAnimating()
                self.arrowIcon.isHidden = true
                self.titleLab.isHidden = true
                self.subTitleLab.isHidden = true
                self.mainLab.isHidden = false
                self.mainLab.text = localizedString(dataModel.title)
            }
        }
    }
   
    
}
