//
//  TXGCDTimer.m
//  carbonDriver
//
//  Created by fst on 2019/4/24.
//  Copyright © 2019 leon. All rights reserved.
//

#import "CRGCDTimer.h"
@interface CRGCDTimer ()
/** 定时器 */
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation CRGCDTimer
- (void)startWithTimeInterval:(NSTimeInterval)ti    Handler:(void (^)(void))handler
{
    // 计时器回调执行的方法所处队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    //1.创建定时器对象，本质是个OC对象，若定义为局部的话，定时器可能会挂掉
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //几秒后开始
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ti * NSEC_PER_SEC));
    //间隔
    uint64_t interval = (uint64_t)(ti * NSEC_PER_SEC);
    //2.设置定时器的相关属性
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    //3. 设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        if (handler)
        {
            handler();
        }
    });
    //4.启动定时器
    dispatch_resume(self.timer);
}

- (void)cancel
{
    // 取消定时器
    if (self.timer)
    {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
}
@end

