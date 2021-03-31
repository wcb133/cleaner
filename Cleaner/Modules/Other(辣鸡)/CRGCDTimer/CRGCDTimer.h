//
//  TXGCDTimer.h
//  carbonDriver
//
//  Created by fst on 2019/4/24.
//  Copyright © 2019 leon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRGCDTimer : NSObject

/**
 创建一个定时器

 @param ti 时间间隔，单位秒
 @param handler 回调
 */
- (void)startWithTimeInterval:(NSTimeInterval)ti    Handler:(void (^)(void))handler;

/**
 关掉定时器
 */
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
