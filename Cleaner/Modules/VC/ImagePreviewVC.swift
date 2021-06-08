//
//  PhotoCheckVC.swift
//  Cleaner
//
//  Created by wcb on 2021/3/27.
//

import UIKit

class ImagePreviewVC: AppBaseVC {

    var image:UIImage = UIImage()
    
    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgView.image = image
        self.view.backgroundColor = .black
        titleView?.title = localizedString("Preview")
    }
}
