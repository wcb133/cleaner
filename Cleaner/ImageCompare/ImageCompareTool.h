//
//  ImageCompare.h
//  合并两个有序链表
//
//  Created by 谢佳培 on 2020/7/31.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageCompareTool : NSObject

/// 是否相似
+ (BOOL)isImage:(UIImage *)image1 likeImage:(UIImage *)image2;

///图片是否模糊
+ (BOOL) isImageFuzzy:(UIImage*)image;

@end
