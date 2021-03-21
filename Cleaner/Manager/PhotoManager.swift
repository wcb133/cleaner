//
//  PhotoManager.swift
//  Cleaner
//
//  Created by fst on 2021/3/15.
//

import UIKit
import Photos

class PhotoModel: NSObject {
    
    var asset:PHAsset!
    var exactImage:UIImage!
    var originImageData:Data!
    var originImageDataLength:Int = 0
    
    init(asset:PHAsset,exactImage:UIImage,originImageData:Data,originImageDataLength:Int) {
        super.init()
        self.asset = asset
        self.exactImage = exactImage
        self.originImageData = originImageData
        self.originImageDataLength = originImageDataLength
    }
    
}

class PhotoManager: NSObject {
    static let shared: PhotoManager = {
        let instance = PhotoManager()
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
    
    //相似照片
    var similarArray:[[PhotoModel]] = []
    var similarSaveSpace = 0
    //截图
    var screenshotsArray:[PhotoModel] = []
    //可以瘦身图片
    var thinPhotoArray:[PhotoModel] = []
    //模糊图片
    var fuzzyPhotoArray:[PhotoModel] = []
    
    var thinPhotoSaveSpace:Int = 0
    
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
            self.completionHandler(true,nil)
            return
        }
        
        let asset = assetPhotos[index]
        if asset.mediaType != .image {//不是图片，取下一张图片
            requestImage(index: index + 1)
            return
        }
        
        let imageManager = PHImageManager()
//        autoreleasepool {
//
//        }
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 125, height: 125), contentMode: .default, options: imageRequestOptions) { (image, info) in
            //获取原图
            imageManager.requestImageDataAndOrientation(for: asset, options: self.imageSizeRequestOptions) { (imageData, dataUTI, orientation, info) in
                if imageData == nil {//为空是因为该图片的原图是在iclund上
                    self.requestImage(index: index + 1)
                }else{
                    self.dealImage(index: index, exactImage: image!, originImageData: imageData!)
                }
                
            }
        }
    }
    
    func dealImage(index:Int,exactImage:UIImage,originImageData:Data) {
        guard let assetPhotos = self.assetPhotos else {  return }
        let asset = assetPhotos[index]
        //是否相似
        if let lastAsset = self.lastAsset {
            let isSameDay = isTheSameDay(date1: lastAsset.creationDate, date2: asset.creationDate)
            let isLike = ImageCompare.isImage(self.lastThumImage, like: exactImage)
            if isSameDay && isLike {
                self.updateSimilarArr(asset: asset, exactImage: exactImage, originImageData: originImageData)
                self.isSameWithLastImage = true
            }else{
                self.isSameWithLastImage = false
            }
        } else {
            self.isSameWithLastImage = false
        }
        
        
        //是否截图
        if asset.mediaSubtypes == .photoScreenshot {
            let model = PhotoModel(asset: asset, exactImage: exactImage, originImageData: originImageData, originImageDataLength: originImageData.count)
            screenshotsArray.append(model)
        }
        
        //是否可瘦身
        dealThinPhoto(asset: asset, exactImage: exactImage, originImageData: originImageData)
        //模糊图片
        let isFuzzy = ImageCompare.isImageFuzzy(UIImage(data: originImageData))
        if isFuzzy {
            let model = PhotoModel(asset: asset, exactImage: exactImage, originImageData: originImageData, originImageDataLength: originImageData.count)
            fuzzyPhotoArray.append(model)
        }
        
        self.lastAsset = asset
        self.lastThumImage = exactImage
        self.lastOriImageData = originImageData
        self.requestImage(index: index + 1)
    }
    
    //更新相似图片
    func updateSimilarArr(asset:PHAsset,exactImage:UIImage,originImageData:Data) {
        if !self.isSameWithLastImage {//创建一组新的数据，因为是比较相似，把上一次的也添加进来
            let model = PhotoModel(asset: self.lastAsset!, exactImage: self.lastThumImage!, originImageData: self.lastOriImageData!, originImageDataLength: self.lastOriImageData!.count)
            self.similarArray.append([model])
        }
        
        if let lastSimilars = self.similarArray.last {//添加相似图片到数组中
            let model = PhotoModel(asset: asset, exactImage: exactImage, originImageData: originImageData, originImageDataLength: originImageData.count)
            
            var imageModels:[PhotoModel] = []
            imageModels.append(contentsOf: lastSimilars)
            imageModels.append(model)
            self.similarArray.remove(at: self.similarArray.count - 1)
            self.similarArray.append(imageModels)
        }
        
        self.similarSaveSpace = self.similarSaveSpace + originImageData.count
    }
    
    func dealThinPhoto(asset:PHAsset,exactImage:UIImage,originImageData:Data) {
        //图片已经小于1M，无需瘦身
        if originImageData.count < 1024 * 1024 * 1 { return }
        let model = PhotoModel(asset: asset, exactImage: exactImage, originImageData: originImageData, originImageDataLength: originImageData.count)
        thinPhotoArray.append(model)
        // 瘦身空间 = 原图大小 - 1024.0 * 1024.0
        self.thinPhotoSaveSpace = self.thinPhotoSaveSpace + (originImageData.count - 1024 * 1024)
    }
}

extension PhotoManager{
    
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
         similarArray = []
         similarSaveSpace = 0
        
        screenshotsArray = []
        
        thinPhotoArray  = []
        thinPhotoSaveSpace = 0
        
        fuzzyPhotoArray  = []
        
        
    }
    
    //是否是同一天
    func isTheSameDay(date1:Date?,date2:Date?)->Bool {
        guard let dateOne = date1,let dateTwo = date2 else { return false }
        let calendar = Calendar.current
        let cmp1 = calendar.dateComponents([.year,.month,.day], from: dateOne)
        let cmp2 = calendar.dateComponents([.year,.month,.day], from: dateTwo)
        return cmp1.year == cmp2.year && cmp1.month == cmp2.month && cmp1.day == cmp2.day
    }
    
    class func tipWith(message:String){
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert);
        let left = UIAlertAction(title: "确定", style: .default, handler: nil)
        alert.addAction(left)
        let vc = cKeyWindow!.rootViewController
        vc?.present(alert, animated: true, completion: nil)
    }
}

extension PhotoManager {
    
    // 压缩照片
    func compressImageWithData(imageData:Data,completionHandler:@escaping (UIImage,Int)->Void) {
        if let image = UIImage(data: imageData) {
            let imageDataLength = imageData.count
            self.compressImage(image: image, imageDataLength: imageDataLength, completionHandler: completionHandler)
        }
    }
    
    func compressImage(image:UIImage,imageDataLength:Int,completionHandler:@escaping (UIImage,Int)->Void) {
        DispatchQueue.global().async {
            let imageDictionary = self.compressImage(image: image, imageDataLength: imageDataLength)
            DispatchQueue.main.async {
                let image = imageDictionary["image"] as? UIImage ?? UIImage()
                let imageDataLength = imageDictionary["imageDataLength"] as? Int ?? 0
                completionHandler(image,imageDataLength)
            }
        }
        
    }
    
    // 压缩图片算法，经过图片质量压缩后还没满足要求达到的压缩大小，则再对图片宽高尺寸进行压缩
    func compressImage(image:UIImage,imageDataLength:Int) -> [String:Any] {

        let rate:CGFloat = 1024.0 * 1024.0 / CGFloat(imageDataLength)
        if let data = image.jpegData(compressionQuality: rate){
            //压缩后的照片
            let compressImage = UIImage(data: data);
            // 经过图片质量压缩后还没满足要求达到的压缩大小，则再对图片宽高尺寸进行压缩
            if data.count > 1024 * 1024 {
                
                // 按照压缩比率缩小宽高
                let size = CGSize(width: image.size.width * rate, height: image.size.height * rate)
                let compressImageSecond = self.imageWithImage(image: compressImage!, newSize: size)
                let dataSecond = image.jpegData(compressionQuality: 1)
                if dataSecond!.count > 1024 * 1024 { // 还没有达到要求则递归调用自己
                    return self.compressImage(image: compressImageSecond!, imageDataLength: dataSecond!.count)
                }else{
                    return ["image":compressImageSecond!, "imageDataLength":dataSecond!.count]
                }
            }else{
                return ["image":compressImage!, "imageDataLength":data.count]
            }
        }else{
            return [:]
        }
    }
    
    //按比例压缩
    func imageWithImage(image:UIImage,newSize:CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
