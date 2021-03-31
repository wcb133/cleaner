//
//  BKCommentInputView.swift
//  BankeBus
//
//  Created by jemi on 2021/1/7.
//  Copyright © 2021 jemi. All rights reserved.
//

import UIKit

class BKCommentInputView: UIView,LoadNibable {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var textView: QMUITextView!
    
    @IBOutlet weak var img1: UIImageView!
    
    @IBOutlet weak var deleteBtn1: UIButton!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var deleteBtn2: UIButton!
    
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var deleteBtn3: UIButton!
    
    var currentTag = 0
    var backImgBlock:(()->Void) = {}
    var imgArray:[UIImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 8
        bgView.layer.masksToBounds = true
        
        textView.placeholderColor = HEX("#999999")
        textView.textColor = HEX("#333333")
        
        deleteBtn1.isHidden = true
        deleteBtn2.isHidden = true
        deleteBtn3.isHidden = true
        img2.isHidden = true
        img3.isHidden = true
        
        img1.contentMode = .scaleAspectFill
        img1.layer.masksToBounds = true
        img1.isUserInteractionEnabled = true
        let tap1 = UITapGestureRecognizer()
        img1.addGestureRecognizer(tap1)
        tap1.rx.event.subscribe(onNext: {[weak self] (tap) in
            self?.showActionSheet(1)
        }).disposed(by: rx.disposeBag)
        
        img2.contentMode = .scaleAspectFill
        img2.layer.masksToBounds = true
        img2.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer()
        img2.addGestureRecognizer(tap2)
        tap2.rx.event.subscribe(onNext: {[weak self] (tap) in
            self?.showActionSheet(2)
        }).disposed(by: rx.disposeBag)
        
        img3.contentMode = .scaleAspectFill
        img3.layer.masksToBounds = true
        img3.isUserInteractionEnabled = true
        let tap3 = UITapGestureRecognizer()
        img3.addGestureRecognizer(tap3)
        tap3.rx.event.subscribe(onNext: {[weak self] (tap) in
            self?.showActionSheet(3)
        }).disposed(by: rx.disposeBag)
    }
    
    
    @IBAction func deleteAction1(_ sender: Any) {
        imgArray.remove(at: 0)
        if deleteBtn2.isHidden == false && deleteBtn3.isHidden == false {
            deleteBtn3.isHidden = true
            img1.image = img2.image
            img2.image = img3.image
            img3.image = UIImage(named: "添加图片按钮")
        }else if deleteBtn3.isHidden && deleteBtn2.isHidden == false {
            
            img3.isHidden = true
            deleteBtn2.isHidden = true
            img1.image = img2.image
            img2.image = UIImage(named: "添加图片按钮")
        }else if deleteBtn3.isHidden && deleteBtn2.isHidden{
            img2.isHidden = true
            img1.image = UIImage(named: "添加图片按钮")
            deleteBtn1.isHidden = true
        }
    }
    
    @IBAction func deleteAction2(_ sender: Any) {
        if deleteBtn3.isHidden {
            imgArray.remove(at: 1)
            img2.image = UIImage(named: "添加图片按钮")
            img3.isHidden = true
            deleteBtn2.isHidden = true
        }else {
            imgArray.remove(at: 2)
            deleteBtn3.isHidden = true
            img2.image = img3.image
            img3.image = UIImage(named: "添加图片按钮")
        }
    }
    
    @IBAction func deleteAction3(_ sender: Any) {
        imgArray.remove(at: 2)
        img3.image = UIImage(named: "添加图片按钮")
        deleteBtn3.isHidden = true
    }
    
}


extension BKCommentInputView:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func showActionSheet(_ btnTag:Int) {
        currentTag = btnTag
        let action = QMUIAlertAction(title: "拍照", style: .default) { (vc, action) in
            self.selectCamera()
        }
        let action1 = QMUIAlertAction(title: "相册选择", style: .default) { (vc, action) in
            self.judgeAlbumPermissions()
        }
        let action2 = QMUIAlertAction(title: "取消", style: .cancel) { (vc, action) in
                   
        }
        action.buttonAttributes = [NSAttributedString.Key.foregroundColor:HEX("#3890F9"),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)]
        action1.buttonAttributes = [NSAttributedString.Key.foregroundColor:HEX("#3890F9"),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)]
        action2.buttonAttributes = [NSAttributedString.Key.foregroundColor:HEX("#999999"),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)]
        let alVC = QMUIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alVC.addAction(action)
        alVC.addAction(action1)
        alVC.addAction(action2)
        alVC.showWith(animated: true)
    }
    
    
    func judgeAlbumPermissions() {
        
        // 获取相册权限
        let authStatus = PHPhotoLibrary.authorizationStatus()
        
        //用户尚未授权
        if authStatus == .notDetermined {
            // 第一次触发授权 alert
            PHPhotoLibrary.requestAuthorization({ [weak self] (states) in
                OperationQueue.main.addOperation {
                    guard let strongSelf = self else { return }
                    if states == .authorized {
                        strongSelf.openPhoto()
                    } else if states == .restricted || states == .denied {
                        // 提示没权限
                        QMUITips.show(withText: "无相册权限！")
                    }
                }
            })
            
        } else if authStatus == .authorized {
            // 可以访问 去打开相册
            self.openPhoto()
            
        } else if authStatus == .restricted || authStatus == .denied {
            // App无权访问照片库 用户已明确拒绝
            QMUITips.show(withText: "无相册权限！")
        }
        
    }
    
    func openPhoto() {
        
        let photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
//        photoPicker.allowsEditing = true
        photoPicker.sourceType = .photoLibrary
        photoPicker.modalPresentationStyle = .fullScreen
        AppBaseNav.currentNavigationController()?.present(photoPicker, animated: true, completion: nil)
    }
    
    
    func selectCamera() {
        // 判断相机权限
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        //用户尚未授权
        if authStatus == .notDetermined {
            // 第一次触发授权 alert
            PHPhotoLibrary.requestAuthorization({ [weak self] (states) in
                // 判断用户选择了什么
                OperationQueue.main.addOperation {
                    guard let strongSelf = self else { return }
                    
                    if states == .authorized {
                        strongSelf.openCamera()
                        
                    } else if states == .restricted || states == .denied {
                        // 提示没权限
                        QMUITips.show(withText: "无相机权限！")
                    }
                }
            })
            
        } else if authStatus == .authorized {
            // 可以访问 去打开相机
            self.openCamera()
            
        } else if authStatus == .restricted || authStatus == .denied {
            // App无权访问照片库 用户已明确拒绝
            QMUITips.show(withText: "无相机权限！")
        }
    }
    
    // 打开相机
    func openCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            //在需要的地方present出来
            OperationQueue.main.addOperation {
                let cameraPicker = UIImagePickerController()
                cameraPicker.delegate = self
//                cameraPicker.allowsEditing = true
                cameraPicker.sourceType = .camera
                AppBaseNav.currentNavigationController()?.present(cameraPicker, animated: true, completion: nil)
            }
            
        } else {
            
            print("不支持拍照")
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) {
            
        }
        let image : UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imgArray.append(image)
        if currentTag == 1 {
            img1.image = image
            img2.isHidden = false
            deleteBtn1.isHidden = false
        }else if currentTag == 2 {
            img2.image = image
            img3.isHidden = false
            deleteBtn2.isHidden = false
        }else  {
            img3.image = image
            deleteBtn3.isHidden = false
        }
        
        backImgBlock()
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            
        }
    }
    
}
