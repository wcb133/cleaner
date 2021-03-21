//
//  ViewController.swift
//  Cleaner
//
//  Created by fst on 2021/3/12.
//

import UIKit

class mainVC: BaseVC {
    
    let circularProgressView =  CircularProgressView(frame: CGRect(x: 0, y: 150, width: 200, height: 200))

    override func viewDidLoad() {
        super.viewDidLoad()
        //照片
//        PhotoManager.shared.loadPhoto { (idx, total) in
//
//        } completionHandler: { (isSuccess, error) in
//            if isSuccess{
////                self.setupUI()
//                self.setupFuzzyUI()
//            }
//        }
        
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //通讯录
//        ClearContactManager.shared.getRepeatContact { contactSectonModels,contactCount in
//
//        }
        
//        CalendarManager.shared.getOutOfDateCalendarEvent { (eventModels) in
//
//        }
        
//        CalendarManager.shared.getOutOfDateReminder { reminderModels in
//
//        }
        
        
        
        
//        VideoManager.shared.loadVideo { (idx, total) in
//
//        } completionHandler: { (isSuccess, error) in
//            if isSuccess{
//                self.setupVideoUI()
//            }
//        }
        
//        MemoryManager.getTotalSpace()
        
        
        
//        circularProgressView.progress = 10
//        self.view.addSubview(circularProgressView)
//        circularProgressView.backgroundColor = .green;
//        test()
        
//        self.navigationController?.pushViewController(ContactVC(), animated: true)
        
//        self.navigationController?.pushViewController(CalendarMainVC(), animated: true)
        
        self.navigationController?.pushViewController(PhotoAndVideoClearVC(), animated: true)
        
        
        
        
    }
    
    func test()  {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.circularProgressView.progress = self.circularProgressView.progress + 1
            if self.circularProgressView.progress < 100.0 {
                self.test()
            }
            
        }
    }

    func setupUI() {
        for (row,photos) in PhotoManager.shared.similarArray.enumerated() {
            for (column,photo) in photos.enumerated() {
               let img = UIImageView()
                view.addSubview(img)
                img.frame = CGRect(x: 110 * column + 10, y: 110 * row + 100, width: 100, height: 100)
                img.image = photo.exactImage
                img.clipsToBounds = true
            }
        }
        
    }
    
    func setupVideoUI() {
        for (row,photos) in VideoManager.shared.sameVideoArray.enumerated() {
            for (column,photo) in photos.enumerated() {
               let img = UIImageView()
                view.addSubview(img)
                img.frame = CGRect(x: 110 * column + 10, y: 110 * row + 100, width: 100, height: 100)
                img.image = photo.exactImage
                img.clipsToBounds = true
            }
        }
    }
    
//    func setupFuzzyUI() {
//        for (row,photo) in PhotoManager.shared.fuzzyPhotoArray.enumerated() {
//            let img = UIImageView()
//            view.addSubview(img)
//            img.frame = CGRect(x: 110 * row + 10, y: 110, width: 100, height: 100)
//            img.image = photo.exactImage
//            img.clipsToBounds = true
//        }
//    }
    
    

}

