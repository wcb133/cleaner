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
    var originImageDataLength:Int = 0
    //是否选中
    var isSelect = false
    
    init(asset:PHAsset,exactImage:UIImage,originImageDataLength:Int) {
        super.init()
        self.asset = asset
        self.exactImage = exactImage
        self.originImageDataLength = originImageDataLength
    }
    
    deinit {
        print("======释放了")
    }
    
}
