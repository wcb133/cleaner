//
//  MemoryManager.swift
//  Cleaner
//
//  Created by fst on 2021/3/18.
//

import UIKit

class MemoryManager: NSObject {
    
    //返回的数据单位是G
    class  func getTotalSpace() -> Float {
        return self.getMemory(isTotal: true)
    }
    
    //返回的数据单位是G
    class  func getUsedSpace() -> Float {
        return self.getMemory(isTotal: false)
    }
    
    
    private class func getMemory(isTotal:Bool) -> Float {
        var totalSpace:Float = 0
        var totalFreeSpace:Float = 0
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let systemPath = paths.last {
            if let dict = try? FileManager.default.attributesOfFileSystem(forPath: systemPath) {
                
                let fileSystemSize = dict[FileAttributeKey.systemSize] as? Int64 ?? 0
                let freeFileSystemSize = dict[FileAttributeKey.systemFreeSize] as? Int64 ?? 0
                totalSpace = Float(fileSystemSize) / (1000.0 * 1000.0 * 1000.0)
                totalFreeSpace = Float(freeFileSystemSize) / (1000.0 * 1000.0 * 1000.0)
            }
        }
        return isTotal ? totalSpace:(totalSpace - totalFreeSpace)
        
    }
}
