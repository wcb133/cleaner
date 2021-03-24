//
//  PhotoModel.swift
//  Cleaner
//
//  Created by wcb on 2021/3/23.
//

import UIKit
import Photos

class PhotoModel: NSObject {
    
    var asset:PHAsset = PHAsset()
    var exactImage:UIImage!
    var originImageData:Data!
    var originImageDataLength:Int = 0
    //是否选中
    var isSelect = false
    
    init(asset:PHAsset,exactImage:UIImage,originImageData:Data,originImageDataLength:Int) {
        super.init()
        self.asset = asset
        self.exactImage = exactImage
        self.originImageData = originImageData
        self.originImageDataLength = originImageDataLength
    }
    
}
