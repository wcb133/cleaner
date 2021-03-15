//
//  ClearPhotoManager.swift
//  Cleaner
//
//  Created by fst on 2021/3/15.
//

import UIKit
import Photos

class ClearPhotoManager: NSObject {
    static let shared: ClearPhotoManager = {
        let instance = ClearPhotoManager()
        return instance
    }()
    
    //所有图片
    var assetPhotos:PHFetchResult<PHAsset>?
    //上一张图片
    var lastAsset:PHAsset?
    //上一张缩略图
    var lastThumImage:UIImage?
    //上一张原图
    var lastOriImageData:Data?
    //这张图片和上一张是否相似
    var isSameWithLastImage = false
    
    
    var similarArray:[[String:Any]] = []
    var screenshotsArray:[[String:Any]] = []
    var thinPhotoArray:[[String:Any]] = []
    
    var processHandler:(Int,Int)->Void = {_,_ in}
    var completionHandler:(Bool,Error?)->Void = {_,_ in}
    
    lazy var imageRequestOptions:PHImageRequestOptions = {
       let options = PHImageRequestOptions()
        options.resizeMode = .none
        options.deliveryMode = .highQualityFormat
        return options
    }()
    
    lazy var imageSizeRequestOptions:PHImageRequestOptions = {
       let options = PHImageRequestOptions()
        options.resizeMode = .exact
        options.deliveryMode = .highQualityFormat
        return options
    }()
    
    
    //删除照片
    class func deleteAsset(assets:[PHAsset],completionHandler:@escaping (Bool,Error?)->Void){
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets(assets as NSFastEnumeration)
        } completionHandler: { (success, error) in
            completionHandler(success,error)
        }
    }
    
    class func tipWith(message:String){
        let alert = UIAlertController(title: "提示", message: "测试", preferredStyle: .alert);
        let left = UIAlertAction(title: "确定", style: .default, handler: nil)
        alert.addAction(left)
        let vc = cKeyWindow!.rootViewController
        vc?.present(alert, animated: true, completion: nil)
    }

    //加载图片
    func loadPhoto(process:@escaping (Int,Int)->Void,completionHandler:@escaping (Bool,Error?)->Void) {
        resetData()
        self.processHandler = process
        self.completionHandler = completionHandler
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        if authorizationStatus == .authorized {
            getAllAsset()
        }else if authorizationStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    self.getAllAsset()
                }
            }
        }else{
            self.noticeAlert()
        }
    }
    
    //获取所有图片
    func getAllAsset() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let result = PHAsset.fetchAssets(with: options)
        self.assetPhotos = result
        self.requestImage(index: 0)
    }
    
    func requestImage(index:Int) {
        guard let assetPhotos = self.assetPhotos else {  return }
        self.processHandler(index,assetPhotos.count)
        //遍历结束
        if index >= assetPhotos.count{
            loadCompletion()
            self.completionHandler(true,nil)
            return
        }
        
        let asset = assetPhotos[index]
        if asset.mediaType != .image {//不是相册，取下一张图片
            requestImage(index: index + 1)
            return
        }
        
        let imageManager = PHImageManager()
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 125, height: 125), contentMode: .default, options: imageRequestOptions) { (image, info) in
            imageManager.requestImageDataAndOrientation(for: asset, options: self.imageSizeRequestOptions) { (imageData, dataUTI, orientation, info) in
                
            }
        }
    }
    
    func dealImage(index:Int,exactImage:UIImage,originImageData:Data) {
        guard let assetPhotos = self.assetPhotos else {  return }
        guard let lastAsset = self.lastAsset else {  return }
        let asset = assetPhotos[index]
        let isSameDay = isTheSameDay(date1: lastAsset.creationDate, date2: asset.creationDate)
        //是否相似
        //是否截图
        //是否可瘦身
        self.lastAsset = asset
        self.lastThumImage = exactImage
        self.lastOriImageData = originImageData
        self.requestImage(index: index + 1)
    }
    
    func loadCompletion() {
        
    }
    
    func getInfoWithDataArray(dataArray:[[String:Any]],saveSpace:Int) -> [String:Any] {
//        var similarCount = 0
//        for dict in dataArray {
//            let array = dict.values
//        }
        
        return [:]
        
    }
    
    //是否是同一天
    func isTheSameDay(date1:Date?,date2:Date?)->Bool {
        return false
    }
    
}

extension ClearPhotoManager{
    
    //弹框提示开启权限
    func noticeAlert() {
        let alert = UIAlertController(title: "此功能需要相册授权", message: "请您在设置系统中打开授权开关", preferredStyle: .alert);
        let left = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let right = UIAlertAction(title: "前往设置", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(left)
        alert.addAction(right)
        let vc = cKeyWindow!.rootViewController
        vc?.present(alert, animated: true, completion: nil)
    }
    
    //清除旧数据
    private func resetData() {
        
    }
}
