//
//  ViewController.swift
//  Cleaner
//
//  Created by fst on 2021/3/12.
//

import UIKit

class mainVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        //照片
        ClearPhotoManager.shared.loadPhoto { (idx, total) in
            
        } completionHandler: { (isSuccess, error) in
            if isSuccess{
//                self.setupUI()
                self.setupFuzzyUI()
            }
        }
        
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //通讯录
        ClearContactManager.shared.getRepeatContact { contactSectonModels,contactCount in
            
        }
    }
    
    
    
    
    func setupUI() {
        for (row,photos) in ClearPhotoManager.shared.similarArray.enumerated() {
            for (column,photo) in photos.enumerated() {
               let img = UIImageView()
                view.addSubview(img)
                img.frame = CGRect(x: 110 * column + 10, y: 110 * row + 100, width: 100, height: 100)
                img.image = photo.exactImage
                img.clipsToBounds = true
            }
        }
        
    }
    
    func setupFuzzyUI() {
        for (row,photo) in ClearPhotoManager.shared.fuzzyPhotoArray.enumerated() {
            let img = UIImageView()
            view.addSubview(img)
            img.frame = CGRect(x: 110 * row + 10, y: 110, width: 100, height: 100)
            img.image = photo.exactImage
            img.clipsToBounds = true
        }
    }
    
    

}

