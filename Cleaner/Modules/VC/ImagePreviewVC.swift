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
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
