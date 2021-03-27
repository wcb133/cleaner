//
//  PhotoAndVideoManager.swift
//  Cleaner
//
//  Created by wcb on 2021/3/23.
//

import UIKit
import Photos

enum AnalyseType {
    case photo
    case video
    case all
}


class PhotoAndVideoManager: NSObject {
    static let shared: PhotoAndVideoManager = {
        let instance = PhotoAndVideoManager()
        return instance
    }()
//图片
    //所有图片
    var assetPhotos:PHFetchResult<PHAsset>?
    //上一张图片
    var lastImageAsset:PHAsset?
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
    var screenshotsSaveSpace = 0
    //可以瘦身图片
    var thinPhotoArray:[PhotoModel] = []
    var thinPhotoSaveSpace:Int = 0
    //模糊图片
    var fuzzyPhotoArray:[PhotoModel] = []
    var fuzzyPhotoSaveSpace:Int = 0
    
//视频
    //上一个视频资源
    var lastAsset:PHAsset?
    //上个视频的第一帧
    var lastImageOfVideo:UIImage?
    
    //上一视频
    var lastVideoAsset:AVAsset?
    //这个视频和上一个是否相似
    var isSimilarWithLastVideo = false
    //这个视频和上一个是否相同
    var isSameWithLastVideo = false
    
    var similarVideos:[[VideoModel]] = []
    var similarVideoSpace:Float = 0
    
    var sameVideoArray:[[VideoModel]] = []
    //单位M
    var sameVideoSpace:Float = 0
    
    var badVideoArray:[VideoModel] = []
    var badVideoSpace:Float = 0
    
    var bigVideoArray:[VideoModel] = []
    var bigVideoSpace:Float = 0
    
    
    //停止扫描
    var isStopScan = false
    
    
    var processHandler:(Int,Int)->Void = {_,_ in}
    var completionHandler:(Bool,Error?)->Void = {_,_ in}
    
    let imageManager = PHImageManager()
    
    lazy var imageRequestOptions:PHImageRequestOptions = {
       let options = PHImageRequestOptions()
        options.resizeMode = .fast
        options.deliveryMode = .highQualityFormat
        return options
    }()
    
    lazy var imageSizeRequestOptions:PHImageRequestOptions = {
       let options = PHImageRequestOptions()
        options.resizeMode = .fast
        options.deliveryMode = .highQualityFormat
//        options.isNetworkAccessAllowed
        return options
    }()
    
    lazy var videoRequestOptions:PHVideoRequestOptions = {
       let options = PHVideoRequestOptions()
        options.version = .current
        options.deliveryMode = .automatic
        return options
    }()
    
    
    //删除照片
    func deleteAsset(assets:[PHAsset],completionHandler:@escaping (Bool,Error?)->Void){
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets(assets as NSFastEnumeration)
        } completionHandler: { (success, error) in
            DispatchQueue.main.async {
                completionHandler(success,error)
            }
        }
    }
    
    //分析图片
    func loadPhoto(process:@escaping (Int,Int)->Void,completionHandler:@escaping (Bool,Error?)->Void) {
        self.loadAsset(process: process, completionHandler: completionHandler,analyseType:.photo)
    }
    
    //分析全部资源
    func loadAllAsset(process:@escaping (Int,Int)->Void,completionHandler:@escaping (Bool,Error?)->Void) {
        self.loadAsset(process: process, completionHandler: completionHandler,analyseType:.all)
    }

    //加载相册资源
    private func loadAsset(process:@escaping (Int,Int)->Void,completionHandler:@escaping (Bool,Error?)->Void,analyseType:AnalyseType) {
        resetData()
        self.processHandler = process
        self.completionHandler = completionHandler
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        if authorizationStatus == .authorized {
            getAllAsset(analyseType: analyseType)
        }else if authorizationStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    self.getAllAsset(analyseType: analyseType)
                }else{
                    DispatchQueue.main.async {
                        self.noticeAlert()
                    }
                }
            }
        }else{
            self.noticeAlert()
        }
    }
    
    //获取所有图片
    func getAllAsset(analyseType:AnalyseType) {
        self.isStopScan = false
        DispatchQueue.global().async {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let result = PHAsset.fetchAssets(with: options)
            self.assetPhotos = result
            self.requestImage(index: 0,analyseType: analyseType)
        }
    }
    
    func requestImage(index:Int,analyseType:AnalyseType) {
        if  self.isStopScan {//停止扫描
            self.isStopScan = false//恢复可扫描
            return
        }
        guard let assetPhotos = self.assetPhotos else {  return }
        DispatchQueue.main.async {
            self.processHandler(index,assetPhotos.count)
        }
        //遍历结束
        if index >= assetPhotos.count {
            DispatchQueue.main.async {
                self.completionHandler(true,nil)
                //释放资源
                self.assetPhotos = nil
            }
            return
        }
        
        let asset = assetPhotos[index]
        if asset.mediaType == .image && (analyseType == .photo || analyseType == .all) {//不是图片，取下一张图片
           let _ = autoreleasepool {
                imageManager.requestImage(for: asset, targetSize: CGSize(width: 600, height: 800), contentMode: .default, options: imageRequestOptions) { (image, info) in
                    //获取原图
                    if #available(iOS 13.0, *) {
                        self.imageManager.requestImageDataAndOrientation(for: asset, options: self.imageSizeRequestOptions) { (imageData, dataUTI, orientation, info) in
                            if imageData == nil {//为空是因为该图片的原图是在iclound上
                                DispatchQueue.global().async {
                                    self.requestImage(index: index + 1,analyseType: analyseType)
                                }
                            }else{
                                DispatchQueue.global().async {
                                    self.dealImage(index: index, exactImage: image!, originImageData: imageData!,analyseType: analyseType)
                                }
                            }
                        }
                    }else{
                        self.imageManager.requestImageData(for: asset, options: self.imageSizeRequestOptions) { (imageData, dataUTI, orientation, info) in
                            if imageData == nil {//为空是因为该图片的原图是在iclound上
                                DispatchQueue.global().async {
                                    self.requestImage(index: index + 1,analyseType: analyseType)
                                }
                            }else{
                                DispatchQueue.global().async {
                                    self.dealImage(index: index, exactImage: image!, originImageData: imageData!,analyseType: analyseType)
                                }
                            }
                        }
                    }
                }
            }
        }else if asset.mediaType == .video && (analyseType == .video || analyseType == .all) {
            imageManager.requestImage(for: asset, targetSize: CGSize(width: 600, height: 800), contentMode: .default, options: imageRequestOptions) { (image, info) in
                self.imageManager.requestAVAsset(forVideo: asset, options: self.videoRequestOptions) { (avasset, audioMix, info) in
                    if let tmpAvasset = avasset {
                        DispatchQueue.global().async {
                            
                            var firstImage:UIImage = UIImage()
                            if let tmpImage = image{
                                firstImage = tmpImage
                            }else{//系统没有缩略图就获取第一帧
                                firstImage = self.getVideoTargetImage(asset: tmpAvasset, targetTime: 0.0)
                            }
                            self.dealVideo(index: index,exactImage:firstImage, videoAsset: tmpAvasset,analyseType: analyseType)
                        }
                    }else{
                        DispatchQueue.global().async {
                            self.requestImage(index: index + 1,analyseType: analyseType)
                        }
                        
                    }
                }
            }

        }else{
            requestImage(index: index + 1,analyseType: analyseType)
            return
        }


    }
    
    func dealImage(index:Int,exactImage:UIImage,originImageData:Data,analyseType:AnalyseType) {
        guard let assetPhotos = self.assetPhotos else {  return }
        let asset = assetPhotos[index]
        //是否相似
        if let lastImageAsset = self.lastImageAsset {
            let isSameDay = isTheSameDay(date1: lastImageAsset.creationDate, date2: asset.creationDate)
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
            self.screenshotsSaveSpace = self.screenshotsSaveSpace + originImageData.count
            model.isSelect = true
            screenshotsArray.append(model)
        }
        
        //是否可瘦身
        dealThinPhoto(asset: asset, exactImage: exactImage, originImageData: originImageData)
        //模糊图片
        let isFuzzy = ImageCompare.isImageFuzzy(exactImage)
        if isFuzzy {
            let model = PhotoModel(asset: asset, exactImage: exactImage, originImageData: originImageData, originImageDataLength: originImageData.count)
            self.fuzzyPhotoSaveSpace = self.fuzzyPhotoSaveSpace + originImageData.count
            model.isSelect = true
            fuzzyPhotoArray.append(model)
        }
        
        self.lastImageAsset = asset
        self.lastThumImage = exactImage
        self.lastOriImageData = originImageData
        self.requestImage(index: index + 1,analyseType:analyseType)
    }
    
    //更新相似图片
    func updateSimilarArr(asset:PHAsset,exactImage:UIImage,originImageData:Data) {
        if !self.isSameWithLastImage {//创建一组新的数据，因为是比较相似，把上一次的也添加进来
            let model = PhotoModel(asset: self.lastImageAsset!, exactImage: self.lastThumImage!, originImageData: self.lastOriImageData!, originImageDataLength: self.lastOriImageData!.count)
            self.similarSaveSpace = self.similarSaveSpace + self.lastOriImageData!.count
            //相似的第一张不选中
            model.isSelect = false
            self.similarArray.append([model])
        }
        
        if let lastSimilars = self.similarArray.last {//添加相似图片到数组中
            let model = PhotoModel(asset: asset, exactImage: exactImage, originImageData: originImageData, originImageDataLength: originImageData.count)
            model.isSelect = true
            var imageModels:[PhotoModel] = []
            imageModels.append(contentsOf: lastSimilars)
            imageModels.append(model)
            self.similarArray.remove(at: self.similarArray.count - 1)
            self.similarArray.append(imageModels)
        }
        
        self.similarSaveSpace = self.similarSaveSpace + originImageData.count
    }
    
    func dealThinPhoto(asset:PHAsset,exactImage:UIImage,originImageData:Data) {
        //图片已经小于2M，无需瘦身
        if originImageData.count < 1024 * 1024 * 2 { return }
        let model = PhotoModel(asset: asset, exactImage: exactImage, originImageData: originImageData, originImageDataLength: originImageData.count)
        model.isSelect = true
        thinPhotoArray.append(model)
        // 瘦身空间 = 原图大小 - 1024.0 * 1024.0 * 2
        self.thinPhotoSaveSpace = self.thinPhotoSaveSpace + originImageData.count
    }
}

extension PhotoAndVideoManager {
    //加载视频
    func loadVideo(process:@escaping (Int,Int)->Void,completionHandler:@escaping (Bool,Error?)->Void) {
        self.loadAsset(process: process, completionHandler: completionHandler,analyseType: .video)
    }
    
    func dealVideo(index:Int,exactImage:UIImage,videoAsset:AVAsset,analyseType:AnalyseType) {
        guard let assetPhotos = self.assetPhotos else {  return }
        let asset = assetPhotos[index]
        
        //视频大小
        var videoSize:Float = 0
        if let urlAsset = videoAsset as? AVURLAsset  {
            var size:AnyObject?
           try? (urlAsset.url as NSURL).getResourceValue(&size, forKey: .fileSizeKey)
            if let sizeNum = size as? NSNumber {
                videoSize = sizeNum.floatValue / (1024.0 * 1024.0)
            }
        }
        
        //是否是相似视频
        if let lastAsset = self.lastAsset {
            let isSameDay = isTheSameDay(date1: lastAsset.creationDate, date2: asset.creationDate)
            let isLike = ImageCompare.isImage(self.lastImageOfVideo, like: exactImage)
            if isSameDay && isLike {
                self.updateSimilarVideos(asset: asset, exactImage: exactImage, videoAsset: videoAsset,videoSize:videoSize)
                self.isSimilarWithLastVideo = true
                //是否相同
                if lastVideoAsset!.duration == videoAsset.duration {
                    self.updateSameVideos(asset: asset, exactImage: exactImage, videoAsset: videoAsset, videoSize: videoSize)
                    self.isSameWithLastVideo = true
                }else{
                    self.isSameWithLastVideo = false
                }

            }else{
                self.isSimilarWithLastVideo = false
                self.isSameWithLastVideo = false
            }
        } else {
            self.isSimilarWithLastVideo = false
            self.isSameWithLastVideo = false
        }
        

        //是否是大视频
        if videoSize > 100.0 {
            let model = VideoModel(asset: asset, exactImage: exactImage, videoAsset: videoAsset, videoSize: videoSize)
            self.bigVideoArray.append(model)
            model.isSelect = true
            self.sameVideoSpace = self.sameVideoSpace + videoSize
        }
        //视频是否损坏
        
        
        
        self.lastAsset = asset
        self.lastImageOfVideo = exactImage
        self.lastVideoAsset = videoAsset
        self.requestImage(index: index + 1,analyseType: analyseType)
    }
    
    //更新相似图片
    func updateSimilarVideos(asset:PHAsset,exactImage:UIImage,videoAsset:AVAsset,videoSize:Float) {
            
        if !self.isSimilarWithLastVideo {//创建一组新的数据，因为是比较相似，把上一次的也添加进来
            var lastVideoSize:Float = 0
            if let urlAsset = videoAsset as? AVURLAsset  {
               var size:AnyObject?
               try? (urlAsset.url as NSURL).getResourceValue(&size, forKey: .fileSizeKey)
                if let sizeNum = size as? NSNumber {
                    lastVideoSize = sizeNum.floatValue / (1024.0 * 1024.0)
                }
            }
            let model = VideoModel(asset: self.lastAsset!, exactImage: self.lastImageOfVideo!, videoAsset: self.lastVideoAsset!, videoSize:lastVideoSize)
            model.isSelect = false
            self.similarVideoSpace = self.similarVideoSpace + lastVideoSize
            self.similarVideos.append([model])
            
        }
        
        if let lastSimilars = self.similarVideos.last {//添加相似图片到数组中
            let model = VideoModel(asset: asset, exactImage: exactImage, videoAsset: videoAsset, videoSize: videoSize)
            model.isSelect = true
            var imageModels:[VideoModel] = []
            imageModels.append(contentsOf: lastSimilars)
            imageModels.append(model)
            self.similarVideos.remove(at: self.similarVideos.count - 1)
            self.similarVideos.append(imageModels)
        }
        self.similarVideoSpace = self.similarVideoSpace + videoSize
    }
    
    func updateSameVideos(asset:PHAsset,exactImage:UIImage,videoAsset:AVAsset,videoSize:Float) {
            
        if !self.isSameWithLastVideo {//创建一组新的数据，因为是比较相同，把上一次的也添加进来
            var lastVideoSize:Float = 0
            if let urlAsset = videoAsset as? AVURLAsset  {
               var size:AnyObject?
               try? (urlAsset.url as NSURL).getResourceValue(&size, forKey: .fileSizeKey)
                if let sizeNum = size as? NSNumber {
                    lastVideoSize = sizeNum.floatValue / (1024.0 * 1024.0)
                }
            }
            let model = VideoModel(asset: self.lastAsset!, exactImage: self.lastImageOfVideo!, videoAsset: self.lastVideoAsset!, videoSize:lastVideoSize)
            self.sameVideoSpace = self.sameVideoSpace + lastVideoSize
            self.sameVideoArray.append([model])
            
        }
        
        if let lastSimilars = self.sameVideoArray.last {//添加相似图片到数组中
            let model = VideoModel(asset: asset, exactImage: exactImage, videoAsset: videoAsset, videoSize: videoSize)
            model.isSelect = true
            var imageModels:[VideoModel] = []
            imageModels.append(contentsOf: lastSimilars)
            imageModels.append(model)
            self.sameVideoArray.remove(at: self.sameVideoArray.count - 1)
            self.sameVideoArray.append(imageModels)
            self.sameVideoSpace = self.sameVideoSpace + videoSize
        }
    }
}

extension PhotoAndVideoManager{
        
    //清除旧数据
    func resetData() {
         similarArray = []
         similarSaveSpace = 0
        
        screenshotsArray = []
        screenshotsSaveSpace = 0
        
        thinPhotoArray  = []
        thinPhotoSaveSpace = 0
        
        fuzzyPhotoArray  = []
        fuzzyPhotoSaveSpace = 0
        
            
        
        similarVideos = []
        bigVideoArray  = []
        sameVideoArray = []
        badVideoArray = []
        
        similarVideoSpace = 0
        sameVideoSpace = 0
        badVideoSpace = 0
        bigVideoSpace = 0
        
        
    }
    
    //是否是同一天
    func isTheSameDay(date1:Date?,date2:Date?)->Bool {
        guard let dateOne = date1,let dateTwo = date2 else { return false }
        let calendar = Calendar.current
        let cmp1 = calendar.dateComponents([.year,.month,.day], from: dateOne)
        let cmp2 = calendar.dateComponents([.year,.month,.day], from: dateTwo)
        return cmp1.year == cmp2.year && cmp1.month == cmp2.month && cmp1.day == cmp2.day
    }
    
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
    
    func tipWith(message:String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert);
        let left = UIAlertAction(title: "确定", style: .default, handler: nil)
        alert.addAction(left)
        let vc = cKeyWindow!.rootViewController
        vc?.present(alert, animated: true, completion: nil)
    }
    
    func tipWith(message:String,checkHandle:@escaping ()->Void){
        let alert = UIAlertController(title: "温馨提示", message: message, preferredStyle: .alert)
        let left = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let right = UIAlertAction(title: "确定", style: .default) { action in
            checkHandle()
        }
        alert.addAction(left)
        alert.addAction(right)
        let vc = cKeyWindow!.rootViewController
        vc?.present(alert, animated: true, completion: nil)
    }
}

extension PhotoAndVideoManager {
    
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

extension PhotoAndVideoManager {
    //获取视频的任意一帧
    func getVideoTargetImage(asset:AVAsset,targetTime:Float64) -> UIImage {
        let gen = AVAssetImageGenerator(asset: asset)
        gen.requestedTimeToleranceAfter = .zero
        gen.requestedTimeToleranceBefore = .zero
        gen.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(targetTime, preferredTimescale: 600)
        var actualTime:CMTime = CMTime()
        if let iamge = try? gen.copyCGImage(at: time, actualTime: &actualTime) {
            return UIImage(cgImage: iamge)
        }
        return UIImage()
    }
}

