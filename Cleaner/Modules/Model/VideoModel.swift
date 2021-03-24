//
//  v.swift
//  Cleaner
//
//  Created by wcb on 2021/3/23.
//

import UIKit
import Photos

class VideoModel: NSObject {

    var asset:PHAsset = PHAsset()
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
