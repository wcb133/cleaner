//
//  VideoManager.swift
//  Cleaner
//
//  Created by fst on 2021/3/17.
//

import UIKit
import Photos

class VideoModel: NSObject {

    var asset:PHAsset!
    var exactImage:UIImage!
    var videoAsset:AVAsset!
    //单位M
    var videoSize:Float = 0
    
    //是否选中
    var isSelect = false

    init(asset:PHAsset,exactImage:UIImage,videoAsset:AVAsset,videoSize:Float) {
        super.init()
        self.asset = asset
        self.exactImage = exactImage
        self.videoAsset = videoAsset
        self.videoSize = videoSize
    }

}

class VideoManager: NSObject {
    static let shared: VideoManager = {
        let instance = VideoManager()
        return instance
    }()
    
    //所有相册资源
    var assetPhotos:PHFetchResult<PHAsset>?
    
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
    
    
    
    var processHandler:(Int,Int)->Void = {_,_ in}
    var completionHandler:(Bool,Error?)->Void = {_,_ in}
    
    lazy var videoRequestOptions:PHVideoRequestOptions = {
       let options = PHVideoRequestOptions()
        options.version = .current
        options.deliveryMode = .automatic
        return options
    }()
    
    
    //删除视频
    func deleteAsset(assets:[PHAsset],completionHandler:@escaping (Bool,Error?)->Void){
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets(assets as NSFastEnumeration)
        } completionHandler: { (success, error) in
            DispatchQueue.main.async {
                completionHandler(success,error)
            }
        }
    }

    //加载视频
    func loadVideo(process:@escaping (Int,Int)->Void,completionHandler:@escaping (Bool,Error?)->Void) {
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
    
    //获取所有相册
    func getAllAsset() {
        DispatchQueue.global().async {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let result = PHAsset.fetchAssets(with: options)
            self.assetPhotos = result
            self.requestImage(index: 0)
        }
    }
    
    func requestImage(index:Int) {
        guard let assetPhotos = self.assetPhotos else {  return }
        DispatchQueue.main.async {
            self.processHandler(index,assetPhotos.count)
        }
        
        //遍历结束
        if index >= assetPhotos.count{
            DispatchQueue.main.async {
                self.completionHandler(true,nil)
            }
            
            return
        }
        
        let asset = assetPhotos[index]
        if asset.mediaType != .video {//不是视频，取下一个
            requestImage(index: index + 1)
            return
        }
        
        let imageManager = PHImageManager()
        
        imageManager.requestAVAsset(forVideo: asset, options: videoRequestOptions) { (avasset, audioMix, info) in
            if let tmpAvasset = avasset {
                DispatchQueue.global().async {
                    //获取第一帧
                    let firstImage = self.getVideoTargetImage(asset: tmpAvasset, targetTime: 0.0)
                    self.dealImage(index: index,exactImage:firstImage, videoAsset: tmpAvasset)
                }
            }else{
                DispatchQueue.global().async {
                    self.requestImage(index: index + 1)
                }
                
            }
        }
    }
    
    func dealImage(index:Int,exactImage:UIImage,videoAsset:AVAsset) {
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
        self.requestImage(index: index + 1)
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

extension VideoManager{
    
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
    
    class func tipWith(message:String){
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert);
        let left = UIAlertAction(title: "确定", style: .default, handler: nil)
        alert.addAction(left)
        let vc = cKeyWindow!.rootViewController
        vc?.present(alert, animated: true, completion: nil)
    }
}

extension VideoManager {
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

